
def build_basebox(boxname='gemstone')
  cd 'veewee'
  %w{build validate export}.each do | command |
      sh("vagrant basebox #{command} '#{boxname}'")
  end
end

def install_basebox(boxname="gemstone")
  cd 'veewee'
  sh("vagrant box add '#{boxname}' '#{boxname}.box'")
  cd '..'
end

desc "Create a vagrant basebox for the current version of ubuntu"
task "basebox_build" do
  build_basebox('gemstone')
end

desc "Create basebox for Ubuntu 11.10 with ruby 1.9.2"
task "basebox_build_11_10" do
  build_basebox("gemstone-ubuntu11.10-ruby192")
end
 
#no automaitc dependency on basebox_build yet (takes long time to run
desc "install already built basebox"
task "basebox_install" do
  install_basebox
end

desc "install already built basebox for ubuntu 11.10"
task "basebox_install_11_10" do
  install_basebox("gemstone-ubuntu11.10-ruby192")
end

full_box_name = "gemstone-ubuntu11.10-ruby192-full"
desc "package fully loaded box"
task "package_box" do
  cd 'vagrant'
  rm_rf "package.box"
  rm_rf "#{full_box_name}.box"
  sh("vagrant package --vagrantfile Vagrantfile.pkg #{full_box_name}")
  mv 'package.box', "#{full_box_name}.box"
  cd '..'
end

desc "install fully loaded box"
task "add_packaged_box" => ['package_box'] do
  cd 'vagrant'
  output = `vagrant box list`
  sh("vagrant box remove #{full_box_name}") if output.include?(full_box_name)
  sh("vagrant box add '#{full_box_name}' #{full_box_name}.box")
  cd '..'
end

