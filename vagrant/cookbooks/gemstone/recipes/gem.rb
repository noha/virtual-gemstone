#
# Cookbook Name:: gemstone
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#include_recipe "gemstone::base"
#include_recipe "monit"

port = node[:gemstone][:low_port];
while port <  node[:gemstone][:low_port] + node[:gemstone][:no_gems] do
   monit_gem "fastcgi" do
      gem_name "gem"
      gem_port "#{port}"
      gem_user "#{node[:gemstone][:user]}"
   end
   port += 1
end

directory "/opt/application" do
   owner "#{node[:gemstone][:user]}"
   mode "0755"
   action :create
end

directory "/opt/application/bin" do
   owner "#{node[:gemstone][:user]}"
   mode "0755"
   action :create
end

template "/opt/application/bin/start-gem" do
   source "start-gem.erb"
   owner "root"
   group "root"
   mode "0755"
end

template "/opt/application/bin/gs-start-gem" do
   source "gs-start-gem.erb"
   owner "root"
   group "root"
   mode "0755"
end
