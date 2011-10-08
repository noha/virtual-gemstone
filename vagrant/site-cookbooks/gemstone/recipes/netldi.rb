#
# Cookbook Name:: gemstone
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
include_recipe "gemstone::base"

unless File.exists?("/etc/init.d/netldi")
   template "/etc/init.d/netldi" do
       source "netldi.erb"
       owner "root"
       group "root"
       mode 0755
   end

   bash "adding service port" do
      code <<-EOH
         if [ "`grep gs64ldi /etc/services`" == "" ]; 
         then 
            echo "gs64ldi  50377/tcp      #gemstone netldi" >> /etc/services;
         fi
      EOH
   end

   execute "activating netldi" do
      command "update-rc.d netldi defaults 80 20"
   end

   execute "starting netldi" do
      command "/etc/init.d/netldi start"
   end
end
