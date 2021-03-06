#
# Cookbook Name:: gemstone
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
include_recipe "gemstone::os"

tmp = node[:gemstone][:cache_path] 
base_url = "#{node[:gemstone][:base_url]}"
file = "#{node[:gemstone][:version]}.zip"
dir = "#{node[:gemstone][:dir]}/#{node[:gemstone][:version]}"

archive_local = "#{tmp}/#{file}"
archive_remote = "#{base_url}/#{file}"
unless File.exists?("#{node[:gemstone][:dir]}")
   unless File.exists?("#{tmp}/#{file}")
  # remote_file "#{archive_local}" do
  #    source "#{archive_remote}"
  #    #action :nothing
  #    action :create_if_missing
  # end
   #
      script "download_gemstone" do
         interpreter "bash"
         user "root"
         cwd "#{tmp}"
         code <<-EOH
            wget ftp://ftp.gemstone.com/pub/GemStone64/3.1.0.1/#{file}
         EOH
      end
   end
end

#   http_request "HEAD #{archive_remote}" do
#      message ""
#      url archive_remote
#      action :head
#      if File.exists?(archive_local)
#         headers "If-Modified-Since" => File.mtime(archive_local).httpdate
#      end
#      notifies :create, resources(:remote_file => archive_local), :immediately
#   end

unless File.exists?("#{node[:gemstone][:dir]}")
   execute "unzip #{tmp}/#{file}" do
      cwd "#{node[:gemstone][:dir]}"
   end

   execute "chown -R #{node[:gemstone][:user]} #{node[:gemstone][:dir]}" do
   end

   execute "ln -s #{dir} product" do
      cwd "#{node[:gemstone][:dir]}"
   end

   directory node[:gemstone][:lock_dir] do
      owner "#{node[:gemstone][:user]}"
      mode "0755"
      action :create
   end

   directory node[:gemstone][:log_dir] do
      owner "#{node[:gemstone][:user]}"
      mode "0755"
      action :create
   end
end

#   remote_file "#{node[:gemstone][:dir]}/product/seaside/etc/gemstone.key" do
#      source "http://seaside.gemstone.com/etc/gemstone30.key-GLASS-Linux-2CPU.txt"
#      action :create_if_missing
#   end
