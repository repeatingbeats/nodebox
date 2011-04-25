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
erl_command_line = `erl +V 2>&1`.gsub(/\r/," ").gsub(/\n/," ")
erl_installed = erl_command_line.include? "version #{node[:erlang][:version]}"

if not erl_installed
	include_recipe "build-essential"
	
	node.set[:erlang][:configure_flags] = [
		"--prefix=#{node[:erlang][:dir]}",
	]

	base_uri = "http://erlang.org/download/"
	base_filename = "otp_src_#{node[:erlang][:build_tag]}"
	package_file = "#{base_filename}.tar.gz"

	package "libncurses5-dev" do
	  action :install
	end

	package "openssl" do
	  action :install
	end

	case node[:platform]
	  when "centos","redhat","fedora"
		package "openssl-devel"
	  when "debian","ubuntu"
		package "libssl-dev"
	end

	directory "/tmp/erlang_pkg" do
	  owner "root"
	  mode 0755
	  action :create
	end

	remote_file "/tmp/erlang_pkg/#{package_file}" do
	  source base_uri + package_file
	  owner "root"
	  mode 0644
	end

	execute "erlang-src-unpack" do
	  cwd "/tmp/erlang_pkg"
	  command "tar xvfz #{package_file}"
	end

	execute "erlang-src-configure" do
	  cwd "/tmp/erlang_pkg/#{base_filename}"
	  command "./configure #{node[:erlang][:configure_flags]}"
	end

	execute "erlang-src-make" do
	  cwd "/tmp/erlang_pkg/#{base_filename}"
	  command "make"
	end

	execute "erlang-src-install" do
	  cwd "/tmp/erlang_pkg/#{base_filename}"
	  command "make install"
	end
end
