#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak-search
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

default.riak_search.package[:type] = "binary"
default.riak_search.package.version.major = "0"
default.riak_search.package.version.minor = "14"
default.riak_search.package.version.incremental = "2"
default.riak_search.package.version.build = "1"
if (node[:riak_search][:package][:type]).eql?("source")
	default.riak_search.package.prefix = "/usr/local"
	default.riak_search.package.root_dir = "#{default.riak_search.package.prefix}"
end

