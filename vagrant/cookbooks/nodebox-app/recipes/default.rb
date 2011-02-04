
apt_update = execute "update apt" do
  user "root"
  command "apt-get update"
  action :nothing
end
apt_update.run_action(:run)

%w{vim curl man-db git-core upstart}.each do | pkg |
  install_package = package pkg do
    action :nothing
  end
  install_package.run_action(:install)
end

include_recipe "nodejs"
include_recipe "nodejs::npm"

# change ownership of /usr/local so npm plays nicely with node
bash "give vagrant ownership of /usr/local" do
  user "root"
  code "chown -R vagrant /usr/local"
  not_if `stat -c %U #{node[:nodejs][:dir]}` == "#{node[:node_user]}"
end

# install our required npm modules
node[:node_modules].each do | node_module |
  bash "npm install #{node_module}" do
    user node[:node_user]
    code "npm install #{node_module}"
    not_if "npm list installed | grep '^#{node_module}'"
  end
end

template "/etc/init/#{node[:appname]}.conf" do
  source "upstart.erb"
  owner "root"
  group "root"
  mode 0755
end

