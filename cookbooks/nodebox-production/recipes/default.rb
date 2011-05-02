# Use shared apt-get
include_recipe "apt-get"

apt_update = execute "update apt" do
  user "root"
  command "apt-get update"
  action :nothing
end
apt_update.run_action(:run)

# we don't actually need all these. I just like to have them.
# upstart and monit are required.
%w{vim curl man-db git-core upstart monit}.each do | pkg |
  install_package = package pkg do
    action :nothing
  end
  install_package.run_action(:install)
end

include_recipe "nginx"
include_recipe "riak"
include_recipe "nodejs"
include_recipe "nodejs::npm"

# install our required npm modules
node[:node_modules].each do | node_module |
  bash "npm install #{node_module}" do
    user "root"
    code "npm install #{node_module}"
    not_if "npm list installed | grep '^#{node_module}'"
  end
end