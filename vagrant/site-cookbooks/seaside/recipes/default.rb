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
   code GemStone.doIt("stone-default", "
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
         ((Smalltalk at: #ConfigurationOfSeaside30) project version: '3.0.5') load.
      ].
   
      \\\"fix content length parsing problem. http://code.google.com/p/glassdb/issues/detail?id=298\\\"
      (Smalltalk at: #FSRole) compile: 'contentLengthHeader
         ^((params at: ''CONTENT_LENGTH'' ifAbsent: [''0'']) ifEmpty: [''0'']) asNumber'.
      ")
  
   not_if GemStone.isDefinedClass("stone-default", "WAFastCGIAdaptor")
end
