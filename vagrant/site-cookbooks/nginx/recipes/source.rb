#base recipe installs nginx from apt, and makes sure it is disabled and
#stopped, so that we can copy an nginx compiled from source over the nginx binary from apt
#while still benefitting from e.g. the start stop scripts and logging
#location.
#
include_recipe "nginx::base"


%w{build-essential libpcre3-dev libssl-dev  }.each do | name |
  package name do
    action :install
  end
end

nginx_source_version = "1.2.4"
nginx_build_dir = "/vagrant/nginx_installer/nginx-1.2.4/"
nginx_installer_dir = "/vagrant/nginx_installer"

directory "/vagrant/nginx_installer" do
  owner "root"
  group "root"
  recursive true
end

cookbook_file "/vagrant/nginx_installer/nginx_installer.sh" do
  source "nginx_installer.sh"
  mode "0744"
end

#we use a script instead of remote_file because we need to rename the result and unzip it
script "download upload progress" do
  cwd nginx_installer_dir
  interpreter "bash"
  code <<-ENDOFSCRIPT
wget -N --no-check-certificate https://github.com/masterzen/nginx-upload-progress-module/zipball/v0.9.0
mv v0.9.0 nginx-upload-progress-module-v0.9.0.zip                                                             
unzip nginx-upload-progress-module-v0.9.0.zip
ENDOFSCRIPT
   not_if {FileTest.exists?(IO::File.join(nginx_installer_dir,"nginx-upload-progress-module-v0.9.0.zip"))}
end

execute "compile nginx from source" do
  cwd "/vagrant/nginx_installer"
  command "bash ./nginx_installer.sh"
  user "root"
  not_if { FileTest.exists?(IO::File.join(nginx_build_dir, "objs/nginx")) }
end
        
##http://www.nickager.com/blog/compiling-nginx-to-add-extra-modules?_s=_6ez9BdRc4-16Ktp&_k=Qk7hdWnSQQCfGsKw&_n&8
execute "install nginx binary" do
  cwd nginx_build_dir
  command "cp objs/nginx /usr/sbin/nginx"
  only_if  {FileTest.exists?("/vagrant/nginx_installer/objs/nginx")}
end

template "/etc/nginx/sites-enabled/default" do
   source "server.conf.erb"
   mode 644
   owner "root"
   group "root"
   variables ({
      :server_name => "localhost",
      :application_path => "",
      :upstream => $upstream})
end

service "nginx" do
   supports :start => true, :restart => true, :reload => true
   action [ :enable,  :start]
end