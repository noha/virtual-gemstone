#
# Cookbook Name:: stone-default
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "stone-creator"

execute "creating application directory" do
   command "mkdir /opt/application"
   not_if { FileTest.exists?("/opt/application") }
end

unless File.exists?("/opt/application/stone-default")
   create_stone "default" do
      stone_name "stone-default"
      stone_dir "/opt/application/stone-default"
   end

   #script "update GLASS" do
   #   interpreter "bash"
   #   user        "root"
   #   code GemStone.updateGLASS("stone-default")
   #end
end
