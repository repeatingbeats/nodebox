#
# Author:: Taliesin Sisson (<taliesins@yahoo.com>)
# Cookbook Name:: riak
# Recipe:: default
#
# Copyright (c) 2010 Basho Technologies, Inc.
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
if node[:riak][:package][:type].eql?("source")
	riak_installed = File.directory?("#{node[:riak][:package][:root_dir]}")
else
	riak_installed = false
end

if not riak_installed
	if node[:riak][:package][:type].eql?("source")
		include_recipe "erlang"
	end
	
	case node[:platform]
	  when "centos","redhat","fedora"
		package "openssl-devel"
	  when "debian","ubuntu"
		package "libssl-dev"
	end

	package "libcrypto++-dev" do
	  action :install
	end
	
	package "openssl" do
	  action :install
	end

	version_str = "#{node[:riak][:package][:version][:major]}.#{node[:riak][:package][:version][:minor]}"
	base_uri = "http://downloads.basho.com/riak/riak-#{version_str}/"
	base_filename = "riak-#{version_str}.#{node[:riak][:package][:version][:incremental]}"

	unless node[:riak][:service][:user].eql?("root")
		group "#{node[:riak][:service][:group]}"

		if node[:riak][:package][:type].eql?("binary")
			user "#{node[:riak][:service][:user]}" do
			  gid "#{node[:riak][:service][:group]}"
			  shell "/bin/bash"
			  home "/var/lib/riak"
			  system true
			end
		else
			user "#{node[:riak][:service][:user]}" do
			  gid "#{node[:riak][:service][:group]}"
			  shell "/bin/bash"
			  home "#{node[:riak][:package][:root_dir]}/lib"
			  system true
			end	
		end
	end

	machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
	package_file =  case node[:riak][:package][:type]
					when "binary"
					  case node[:platform]
					  when "debian","ubuntu"
						include_recipe "riak::iptables"
						"#{base_filename.gsub(/\-/, '_')}-#{node[:riak][:package][:version][:build]}_#{machines[node[:kernel][:machine]]}.deb"
					  when "centos","redhat","suse"
						"#{base_filename}-#{node[:riak][:package][:version][:build]}.el5.#{machines[node[:kernel][:machine]]}.rpm"
					  when "fedora"
						"#{base_filename}-#{node[:riak][:package][:version][:build]}.fc12.#{node[:kernel][:machine]}.rpm"
						# when "mac_os_x"
						#  "#{base_filename}.osx.#{node[:kernel][:machine]}.tar.gz"
					  end
					when "source"
					  "#{base_filename}.tar.gz"
					end

	directory "/tmp/riak_pkg" do
	  owner "root"
	  action :create
	  mode 0755
	end

	remote_file "/tmp/riak_pkg/#{package_file}" do
	  source base_uri + package_file
	  owner "root"
	  mode 0644
	  checksum node[:riak][:package][:source_checksum]
	end

	case node[:riak][:package][:type]
	when "binary"
	  package "riak" do
		source "/tmp/riak_pkg/#{package_file}"
		action :install
		provider value_for_platform(
									[ "ubuntu", "debian" ] => {"default" => Chef::Provider::Package::Dpkg},
									[ "redhat", "centos", "fedora", "suse" ] => {"default" => Chef::Provider::Package::Rpm}
									)
	end
	when "source"
	  execute "riak-src-unpack" do
		cwd "/tmp/riak_pkg"
		command "tar xvfz #{package_file}"
	  end

	  execute "riak-src-build" do
		cwd "/tmp/riak_pkg/#{base_filename}"
		command "make clean all rel"
	  end  

	  execute "riak-remove-existing-installation" do
		command "sudo rm -r #{node[:riak][:package][:root_dir]}"
		only_if {File.directory?("#{node[:riak][:package][:root_dir]}") }
	  end
	  
	  directory "#{node[:riak][:package][:root_dir]}" do
		owner "root"
		action :create
		mode 0755
	  end
	  
	  execute "riak-src-install" do
		command "sudo mv /tmp/riak_pkg/#{base_filename}/rel/riak/* #{node[:riak][:package][:root_dir]}"
	  end
	  
	  execute "riak-src-file-permissions" do
		command "sudo chown -R #{node[:riak][:service][:user]}:#{node[:riak][:service][:group]} #{node[:riak][:package][:root_dir]}"
		only_if {File.directory?("#{node[:riak][:package][:root_dir]}") }
	  end
	end

	case node[:riak][:kv][:storage_backend]
	when :riak_kv_innostore_backend
	  include_recipe "riak::innostore"
	end

	directory node[:riak][:package][:config_dir] do
	  owner "#{node[:riak][:service][:user]}"
	  mode "0755"
	  action :create
	end

	template "#{node[:riak][:package][:config_dir]}/app.config" do
	  source "app.config.erb"
	  owner "#{node[:riak][:service][:user]}"
	  mode 0644
	end

	template "#{node[:riak][:package][:config_dir]}/vm.args" do
	  variables :switches => prepare_vm_args(node[:riak][:erlang])
	  source "vm.args.erb"
	  owner "#{node[:riak][:service][:user]}"
	  mode 0644
	end

	template "/etc/init.d/riak" do
	  source "riak_init.erb"
	  owner "root"
	  mode 0755
	  only_if {node[:riak][:package][:type].eql?("source")}
	end


	service "riak" do
		action [ :enable ]
		supports :start => true, :stop => true, :reload => true
		subscribes :reload, resources(:template => [ "#{node[:riak][:package][:config_dir]}/app.config",
												  "#{node[:riak][:package][:config_dir]}/vm.args" ])
	end

end



