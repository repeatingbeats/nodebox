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

riak_search_installed = FileTest.exists?("#{node[:riak_search][:package][:bin_dir]}/riaksearch")

if not riak_search_installed
	version_str = "#{node[:riak_search][:package][:version][:major]}.#{node[:riak_search][:package][:version][:minor]}"
	base_uri = "http://downloads.basho.com/riak-search/riak-search-#{version_str}/"
	base_filename = "riak-search-#{version_str}.#{node[:riak_search][:package][:version][:incremental]}"

	machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
	package_file =  case node[:riak_search][:package][:type]
					when "binary"
						package "openjdk-6-jre" do
							action :install
						end
					  case node[:platform]
					  when "debian","ubuntu"
						"#{base_filename.gsub(/\-/, '_').sub( 'riak_search', 'riak-search' )}-#{node[:riak_search][:package][:version][:build]}_#{machines[node[:kernel][:machine]]}.deb"
					  when "centos","redhat","suse"
						"#{base_filename}-#{node[:riak_search][:package][:version][:build]}.el5.#{machines[node[:kernel][:machine]]}.rpm"
					  when "fedora"
						"#{base_filename}-#{node[:riak_search][:package][:version][:build]}.fc12.#{node[:kernel][:machine]}.rpm"
					  end
					when "source"
						package "build-essential" do
							action :install
						end
						
						package "libc6-dev-i386" do
							action :install
						end
						
						package "openjdk-6-jdk" do
							action :install
						end
						
						package "ant" do
							action :install
						end
						
						package "ant-optional" do
							action :install
						end
						base_filename = base_filename.sub( 'riak-search', 'riak_search' )
						"#{base_filename}.tar.gz"
					end

	directory "/tmp/riak_search_pkg" do
	  owner "root"
	  action :create
	  mode 0755
	end

	remote_file "/tmp/riak_search_pkg/#{package_file}" do
	  source base_uri + package_file
	  owner "root"
	  mode 0644
	  checksum node[:riak_search][:package][:source_checksum]
	end

	case node[:riak_search][:package][:type]
	when "binary"
	  package "riak-search" do
		source "/tmp/riak_search_pkg/#{package_file}"
		action :install
		provider value_for_platform(
									[ "ubuntu", "debian" ] => {"default" => Chef::Provider::Package::Dpkg},
									[ "redhat", "centos", "fedora", "suse" ] => {"default" => Chef::Provider::Package::Rpm}
									)
	end
	when "source"
	  execute "riak-search-src-unpack" do
		cwd "/tmp/riak_search_pkg"
		command "tar xvfz #{package_file}"
	  end

	  execute "riak-search-src-build" do
		cwd "/tmp/riak_search_pkg/#{base_filename}"
		command "make clean all rel"
	  end  

	  execute "riak-search-remove-existing-installation" do
		command "sudo rm -r #{node[:riak_search][:package][:root_dir]}"
		only_if {File.directory?("#{node[:riak_search][:package][:root_dir]}") }
	  end
	  
	  directory "#{node[:riak_search][:package][:root_dir]}" do
		owner "root"
		action :create
		mode 0755
	  end
	  
	  execute "riak-search-src-install" do
		command "sudo mv /tmp/riak_search_pkg/#{base_filename}/rel/riaksearch/* #{node[:riak_search][:package][:root_dir]}"
	  end
	  
	  execute "riak-search-src-file-permissions" do
		command "sudo chown -R #{node[:riak_search][:service][:user]}:#{node[:riak_search][:service][:group]} #{node[:riak_search][:package][:root_dir]}"
		only_if {File.directory?("#{node[:riak_search][:package][:root_dir]}") }
	  end
	end
	
	directory node[:riak_search][:package][:config_dir] do
	  owner "#{node[:riak_search][:service][:user]}"
	  mode "0755"
	  action :create
	end	
	
	template "#{node[:riak_search][:package][:config_dir]}/app.config" do
	  source "app.config.erb"
	  owner "#{node[:riak_search][:service][:user]}"
	  mode 0644
	end

	template "#{node[:riak_search][:package][:config_dir]}/vm.args" do
	  variables :switches => prepare_vm_args(node[:riak_search][:erlang])
	  source "vm.args.erb"
	  owner "#{node[:riak_search][:service][:user]}"
	  mode 0644
	end
	
	template "/etc/init.d/riaksearch" do
	  source "riaksearch_init.erb"
	  owner "root"
	  mode 0755
	  only_if {node[:riak_search][:package][:type].eql?("source")}
	end

	service "riaksearch" do
		action [ :enable ]
		supports :start => true, :stop => true, :reload => true
		subscribes :reload, resources(:template => [ "#{node[:riak][:package][:config_dir]}/app.config",
												  "#{node[:riak][:package][:config_dir]}/vm.args" ])
	end
end



