define :monit_gem do
   template "/etc/monit/conf.d/#{params[:gem_name]}-#{params[:gem_port]}" do
      source "monit_gem.erb"
      owner "root"
      group "root"
      mode "0644"
      variables ({
         :gem_name => params[:gem_name],
         :gem_port => params[:gem_port],
         :gem_user => node[:gemstone][:user]
      })
      notifies :restart, resources(:service => "monit")
   end
end
