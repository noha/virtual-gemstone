#
# Cookbook Name:: seaside
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "gemstone::base"
include_recipe "gemstone::netldi"

script "install seaside" do
   interpreter "bash"
   user        "root"
   code <<-EOH
   source /opt/gemstone/product/seaside/defSeaside
   echo "
set gemstone stone-default
set user DataCurator
set password swordfish
login
run
MCPlatformSupport autoCommit: true.
MCPlatformSupport autoMigrate: true. 
MCPlatformSupport commitOnAlmostOutOfMemoryDuring: [
   ConfigurationOfGLASS project updateProject.
   ConfigurationOfGLASS project latestVersion load ].

ConfigurationOfMetacello project updateProject.
ConfigurationOfMetacello project latestVersion load.

Gofer new
   squeaksource: 'MetacelloRepository';
   package: 'ConfigurationOfSeaside30';
   load.

MCPlatformSupport commitOnAlmostOutOfMemoryDuring: [
   (Smalltalk at: #ConfigurationOfSeaside30) project lastVersion load
].

\\\"fix content length parsing problem. http://code.google.com/p/glassdb/issues/detail?id=298\\\"
FSRole compile: 'contentLengthHeader
   ^((params at: ''CONTENT_LENGTH'' ifAbsent: [''0'']) ifEmpty: [''0'']) asNumber'      
%
commit
logout
exit" | topaz -l
      EOH
end
