# Use shared apt-get
include_recipe "apt-get"

# keep up to date
apt_update = execute "update apt" do
  user "root"
  command "apt-get update"
  action :nothing
end
apt_update.run_action(:run)

# install our required packages modules
node[:node_packages].each do | pkg |
  install_package = package pkg do
    action :nothing
  end
  install_package.run_action(:install)
end

# Setup Riak
include_recipe "riak"

#include_recipe "rabbitmq"

# no webserver! node will listen on port 80. As root! Hence, development.
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

include_recipe "nodejs-application"



