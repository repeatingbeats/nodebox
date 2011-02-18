nb_config = JSON.parse(File.read('../nodebox.json'))

nodebox_env = nb_config['environment']
required_modules = (nodebox_env == 'development') ? [ "supervisor" ] : []
app_modules = nb_config['modules'] && nb_config['modules'].concat(required_modules) || required_modules
app_name = nb_config['app_name']
app_path = "/var/www/#{app_name}"
app_port = (nodebox_env == 'development') ? 80 : nb_config['app_port'] || 8080
recipe = "nodebox-#{nodebox_env}"

Vagrant::Config.run do |vgr_config|

  vgr_config.vm.box = "ubuntu-lucid-32"
  vgr_config.vm.forward_port "web", 80, nb_config['host_port']
  vgr_config.vm.share_folder(app_name, app_path, "./../")

  vgr_config.vm.provision :chef_solo do | chef |
    chef.cookbooks_path = [ "cookbooks", "site-cookbooks" ]
    chef.add_recipe(recipe)
    chef.json.merge!({
      :app => {
        :name => app_name,
        :port => app_port,
        :path => app_path,
      },
      :node_user => "node",
      :nodejs => {
        :version => nb_config['node_version'],
        :npm => nb_config['npm_version']
      },
      :node_modules => app_modules
    });
  end
end

