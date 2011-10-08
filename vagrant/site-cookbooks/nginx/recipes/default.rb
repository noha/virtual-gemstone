#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "nginx" do
  action :install
end

#port = node[:nginx][:low_port];
#$upstream = "";
#while port <  node[:nginx][:low_port] + node[:nginx][:no_gems] do
#   $upstream += "server 127.0.0.1:#port\n";
#   port += 1
#end

template "/etc/nginx/sites-enabled/default" do
   source "server.conf.erb"
   mode 644
   owner "root"
   group "root"
   variables (
      :server_name => "localhost",
      :application_path => "",
      :upstream => $upstream)
end

service "nginx" do
   supports :start => true, :restart => true, :reload => true
   action [ :enable,  :start]
end
