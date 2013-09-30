#
# Cookbook Name:: monit
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#node.default['monit']['start_delay'] = "2"
package "monit" do
  action :install
end

service "monit" do
   supports :restart => true, :reload => true
   action :enable
end

template "monit default config" do
   path "/etc/default/monit"
   source "monit.erb"
   owner "root"
   group "root"
   mode "0644"
   notifies :restart, resources(:service => "monit")
end

template "monit config" do
   path "/etc/monit/monitrc"
   source "monitrc.erb"
   owner "root"
   group "root"
   mode "0644"
   notifies :restart, resources(:service => "monit")
end
#
#   variables({ 
#      :start_delay => node[:monit][:start_delay] 
#   })
