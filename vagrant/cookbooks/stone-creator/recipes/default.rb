#
# Cookbook Name:: stone-creator
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "gemstone"

#execute "fetch stone-creator from gitorious" do
#    command "git clone https://git.gitorious.org/gemstone-tools/stone-creator.git /opt/stone-creator"
#    not_if { FileTest.exists?("/opt/stone-creator") }
#end

unless File.exists?("/opt/stone-creator")
   git "/opt/stone-creator" do
      repository "https://git.gitorious.org/gemstone-tools/stone-creator.git"
      reference "master"
      action :sync
   end

   execute "creating application directory" do
      command "mkdir /opt/application"
      not_if { FileTest.exists?("/opt/application") }
   end

   execute "creating default stone instance" do
      command "/opt/stone-creator/bin/create-stone.sh -n stone-default -d /opt/application/stone-default -f"
      not_if { FileTest.exists?("/opt/application/stone-default") }
   end

   execute "creating symlink to /etc/init.d" do
      command "ln -s /opt/application/stone-default/stone-default /etc/init.d/stone-default"
      not_if { FileTest.exists?("/etc/init.d/stone-default") }
   end

   execute "activating stone-default" do
      command "update-rc.d stone-default defaults"
   end

   execute "starting stone-default" do
      command "/etc/init.d/stone-default start"
   end
end
