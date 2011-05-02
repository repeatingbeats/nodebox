nb_config = JSON.parse(File.read('../nodebox.json'))

nodebox_env = nb_config['environment']
required_modules = (nodebox_env == 'development') ? [ "supervisor" ] : []
app_modules = nb_config['modules'] && nb_config['modules'].concat(required_modules) || required_modules
app_name = nb_config['app_name']
app_path = "/var/www/#{app_name}"
app_port = nb_config['app_port'] || 8080
web_server_port = (nodebox_env == 'production') ? 80 : app_port
recipe = "nodebox-#{nodebox_env}"

Vagrant::Config.run do |vgr_config|

	vgr_config.vm.box = "talifun-ubuntu-11.04-server-amd64"
	vgr_config.vm.forward_port "web", web_server_port, nb_config['host_port']
	vgr_config.vm.share_folder(app_name, app_path, "./../")

	vgr_config.vm.provision :chef_solo do | chef |
		chef.cookbooks_path = [ "cookbooks", "site-cookbooks" ]
		chef.add_recipe(recipe)
		chef.json.merge!({
			:app => {
				:name => app_name,
				:port => app_port,
				:path => app_path,
				:service => {
					:type => "supervisor",
					:name => app_name,
					:user => "vagrant",
				},
			},
			:erlang => {
				:build_tag => "R13B04",
				:version => "5.7.5",
			},	  
			:riak => {
				:service => {
					:name => "riak",
					:user => "riak_service",
				},
				:package => {
					:type => "source",
				},
			},
			:nodejs => {
				:version => "0.4.6",
				:npm => "0.3.18"
			},
			:node_modules => app_modules
		});
	end
end