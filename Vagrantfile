nb_config = JSON.parse(File.read('./nodebox.json'))

nodebox_env = nb_config['environment']
required_packages = (nodebox_env == 'development') ? [] : []
app_packages = nb_config['packages'] && nb_config['packages'].concat(required_packages) || required_packages
required_modules = (nodebox_env == 'development') ? [ "supervisor" ] : []
app_modules = nb_config['modules'] && nb_config['modules'].concat(required_modules) || required_modules
app_name = nb_config['app_name']
app_path = "/var/www/#{app_name}"
app_port = nb_config['app_port'] || 8080
web_server_port = (nodebox_env == 'production') ? 80 : app_port
recipe = "nodebox-#{nodebox_env}"

Vagrant::Config.run do |vgr_config|
	vgr_config.vm.define :web do |web_config|
		web_config.vm.box = "talifun-ubuntu-11.04-server-amd64"
		web_config.vm.forward_port "web", web_server_port, nb_config['host_port']
		web_config.vm.share_folder(app_name, app_path, "./../#{app_name}/")

		web_config.vm.provision :chef_solo do | chef |
			chef.cookbooks_path = [ "cookbooks", "site-cookbooks" ]
			chef.add_recipe(recipe)
			chef.json.merge!({
				:app => {
					:name => app_name,
					:port => app_port,
					:path => app_path,
					:service => {
						:type => "supervisor",
						:name => "#{app_name}_service",
						:user => app_name,
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
						:type => "binary",
					},
				},
				:riak_search => {
					:package => {
						:type => "binary",
					},
				},
				:nodejs => {
					:version => "0.4.9",
					:npm => "1.0.15",
				},
				:packages => app_packages,
				:node_modules => app_modules
			});
		end
	end
end