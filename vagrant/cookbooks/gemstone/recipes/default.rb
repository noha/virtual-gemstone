#
# Cookbook Name:: gemstone
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
tmp = Chef::Config[:file_cache_path]
file = "GemStone64Bit3.0.0Beta4-x86_64.Linux.zip"
dir = "GemStone64Bit3.0.0Beta4-x86_64.Linux"

user node[:gemstone][:user] do
  action :create
  system true
  shell "/bin/false"
end

directory node[:gemstone][:dir] do
  owner "gemstone"
  mode "0755"
  action :create
end

package "unzip" do
  action :install
end

unless File.exists?("#{tmp}/#{file}")
   remote_file "#{tmp}/#{file}" do
      source "http://glass-downloads.gemstone.com/gss30/#{file}"
      action :create_if_missing
   end
end

unless File.exists?("/opt/gemstone/#{dir}/version.txt")
   execute "unzip #{tmp}/#{file}" do
      cwd "/opt/gemstone"
   end

   execute "chown -R gemstone /opt/gemstone" do
   end

   execute "ln -s #{dir} product" do
      cwd "/opt/gemstone"
   end

   remote_file "/opt/gemstone/product/seaside/etc/gemstone.key" do
      source "http://seaside.gemstone.com/etc/gemstone30.key-GLASS-Linux-2CPU.txt"
      action :create_if_missing
   end
end


