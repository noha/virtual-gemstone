#
# Cookbook Name:: stone-creator
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "gemstone::base"

unless File.exists?("/opt/stone-creator")
   git "/opt/stone-creator" do
      repository "git://github.com/noha/stone-creator.git"
      reference "master"
      action :sync
   end
end

directory node[:stone_creator][:etc_dir] do
   owner "#{node[:gemstone][:user]}"
   mode "0755"
   action :create
end

directory node[:stone_creator][:stones_dir] do
   owner "#{node[:gemstone][:user]}"
   mode "0755"
   action :create
end

template "cleanup-stones" do
  path "/opt/application/bin/cleanup-stones"
  source "cleanup-stones.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "cleanup-stones cron" do
  path "/etc/cron.d/cleanup-stones"
  source "cleanup-cron.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "full-backup-stone" do
  path "/opt/application/bin/full-backup-stone"
  source "full-backup-stone.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "backup-stones" do
  path "/opt/application/bin/backup-stones"
  source "backup-stones.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "backup-stones cron" do
  path "/etc/cron.d/backup-stones"
  source "backup-cron.erb"
  owner "root"
  group "root"
  mode "0644"
end

