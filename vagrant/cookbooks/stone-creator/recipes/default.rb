#
# Cookbook Name:: stone-creator
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "gemstone"

unless File.exists?("/opt/stone-creator")
   git "/opt/stone-creator" do
      repository "git://github.com/noha/stone-creator.git"
      reference "master"
      action :sync
   end
end
