#
# Cookbook Name:: gemstone
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
include_recipe "gemstone::os"
require 'net/ftp'

tmp = node[:gemstone][:cache_path]
ftp_url = "#{node[:gemstone][:ftp_url]}"
base_url = "#{node[:gemstone][:base_url]}"
file = "#{node[:gemstone][:version]}.zip"
dir = "#{node[:gemstone][:dir]}/#{node[:gemstone][:version]}"

archive_local = "#{tmp}/#{file}"
archive_remote = "#{base_url}/#{file}"
unless File.exists?("#{dir}/version.txt")
   remote_file "#{archive_local}" do
      source "#{archive_remote}"
      action :nothing
   end


  ftp = Net::FTP.new(ftp_url)
  ftp.passive = true
  ftp.login
  ftp.chdir(base_url)
  ftp.getbinaryfile(file,archive_local)
  ftp.close
   

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

# remote_file "#{node[:gemstone][:dir]}/product/seaside/etc/gemstone.key" do
# source "http://seaside.gemstone.com/etc/gemstone30.key-GLASS-Linux-2CPU.txt"
# action :create_if_missing
# end
end