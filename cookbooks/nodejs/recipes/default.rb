#
# Author:: Marius Ducea (marius@promethost.com)
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2010, Promet Solutions
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
nodejs_commandline = `#{node[:nodejs][:root_dir]}/bin/node -v 2>&1`
nodejs_installed = nodejs_commandline.include? "v#{node[:nodejs][:version]}"

if not nodejs_installed
	include_recipe "build-essential"

	case node[:platform]
	  when "centos","redhat","fedora"
		package "openssl-devel"
	  when "debian","ubuntu"
		package "libssl-dev"
	end

	base_uri = "http://nodejs.org/dist/"
	base_filename = "node-v#{node[:nodejs][:version]}"
	package_file = "#{base_filename}.tar.gz"

	directory "/tmp/nodejs_pkg" do
		owner "root"
		action :create
		mode 0755
	end

	remote_file "/tmp/nodejs_pkg/#{package_file}" do
		source base_uri + package_file
		owner "root"
		mode 0644
	end

	execute "nodejs-src-unpack" do
		cwd "/tmp/nodejs_pkg"
		command "tar xvfz #{package_file}"
	end

	execute "nodejs-src-configure" do
		cwd "/tmp/nodejs_pkg/#{base_filename}"
		command "./configure --prefix=#{node[:nodejs][:root_dir]}"
	end

	execute "nodejs-src-make" do
		cwd "/tmp/nodejs_pkg/#{base_filename}"
		command "make"
	end

	execute "nodejs-src-make-install" do
		cwd "/tmp/nodejs_pkg/#{base_filename}"
		command "make install"
	end
end