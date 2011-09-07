#
# Cookbook Name:: gemstone
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
user node[:gemstone][:user] do
  action :create
  system true
  shell "/bin/bash"
end

directory node[:gemstone][:dir] do
  owner "#{node[:gemstone][:user]}"
  mode "0755"
  action :create
end

package "unzip" do
  action :install
end

bash "adding sysctl settings" do
   code <<-EOH
      if [ "`grep shmmax /etc/sysctl.conf`" == "" ];
      then
         echo "kernel.shmmax=838860800" >> /etc/sysctl.conf
         echo "kernel.shmall=2097152" >> /etc/sysctl.conf
         sysctl -w kernel.shmmax=838860800
         sysctl -w kernel.shmall=2097152
      fi
   EOH
end
