# Cookbook Name:: erlang
# Recipe:: default
# Author:: Taliesin Sisson <taliesins@yahoo.com>
#
# Copyright 2008-2011, Taliesin sisson
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
nodejs_application_installed = File.exists?("/etc/init/#{node[:app][:service][:name]}.conf")
if not nodejs_application_installed
	# create user to run nodejs application
	user "#{node[:app][:service][:user]}" do
	  system true
	  action :create
	end
	
	execute "#{node[:app][:service][:user]}" do
		user "root"
		command "sudo chown -R #{node[:app][:service][:user]} #{node[:app][:path]}"
	end
	
	case node[:app][:service][:type]
	when "supervisor"
		execute "start nodejs application - #{node[:app][:service][:name]}" do
			user "root"
			command "start #{node[:app][:service][:name]}"
			action :nothing
		end

		template "/etc/init/#{node[:app][:service][:name]}.conf" do
			source "supervisor.nodejs-application.conf.erb"
			owner "root"
			group "root"
			mode 0755
			notifies :run, resources(:execute => "start nodejs application - #{node[:app][:service][:name]}")
		end
	else
		execute "start upstart" do
			user "root"
			command "start #{node[:app][:service][:name]}"
			action :nothing
		end

		execute "start monit" do
			user "root"
			command "monit -d 60 -c /etc/monit/monitrc"
			action :nothing
		end

		template "/etc/init/#{node[:app][:service][:name]}.conf" do
			source "nodejs-application.conf.erb"
			owner "root"
			group "root"
			mode 0755
			notifies :run, resources(:execute => "start upstart")
		end

		template "/etc/monit/monitrc" do
			source "monit.erb"
			owner "root"
			group "root"
			mode 0700
			notifies :run, resources(:execute => "start monit")
		end
	end
end