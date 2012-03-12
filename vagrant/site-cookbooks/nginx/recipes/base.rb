#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# Split recipe from base to prevent nginx from starting when e.g.
# installing from source, and allow each of the sub recipes to load
# their own config file.
#
package "nginx" do
  action :install
end

service "nginx" do
   supports :start => true, :restart => true, :reload => true
   action [ :disable,  :stop]
end

#port = node[:nginx][:low_port];
#$upstream = "";
#while port <  node[:nginx][:low_port] + node[:nginx][:no_gems] do
#   $upstream += "server 127.0.0.1:#port\n";
#   port += 1
#end

