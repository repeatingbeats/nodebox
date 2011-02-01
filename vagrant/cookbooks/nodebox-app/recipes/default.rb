
apt_update = execute "update apt" do
  user "root"
  command "apt-get update"
  action :nothing
end
apt_update.run_action(:run)

%w{vim curl man-db git-core}.each do | pkg |
  install_package = package pkg do
    action :nothing
  end
  install_package.run_action(:install)
end

include_recipe "nodejs"
include_recipe "nodejs::npm"

