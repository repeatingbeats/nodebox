#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak
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

include_attribute "riak::core"

default.riak_search.erlang.node_name = "#{default.riak_search.service.name}@#{default.riak_search.core.http[0][0]}"
default.riak_search.erlang.cookie = "riak"
default.riak_search.erlang.kernel_polling = true
default.riak_search.erlang.async_threads = 64
default.riak_search.erlang.smp = "enable"
default.riak_search.erlang.env_vars.ERL_MAX_PORTS = 4096
default.riak_search.erlang.env_vars.ERL_FULLSWEEP_AFTER = 0