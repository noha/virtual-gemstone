define :create_stone do
   execute "creating stone #{params[:stone_name]}" do
      command "/opt/stone-creator/bin/create-stone.sh -n #{params[:stone_name]} -d #{params[:stone_dir]} -f"
      not_if { FileTest.exists?("#{params[:stone_dir]}") }
   end

   execute "creating symlink to /etc/init.d" do
      command "ln -s #{params[:stone_dir]}/#{params[:stone_name]} /etc/init.d/#{params[:stone_name]}"
      not_if { FileTest.exists?("/etc/init.d/#{params[:stone_name]}") }
   end

   execute "activating stone #{params[:stone_name]}" do
      command "update-rc.d #{params[:stone_name]} defaults"
   end

   execute "starting #{params[:stone_name]}" do
      command "/etc/init.d/#{params[:stone_name]} start"
   end

   bash "adding #{params[:stone_name]} to stones.d directory" do
      code <<-EOH 
         echo "STONE_NAME=#{params[:stone_name]}" >> #{node[:stone_creator][:stones_dir]}/#{params[:stone_name]}
         echo "STONE_DIR=#{params[:stone_dir]}" >> #{node[:stone_creator][:stones_dir]}/#{params[:stone_name]}
      EOH
   end
end
