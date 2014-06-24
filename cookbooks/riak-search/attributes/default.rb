#
# Author:: Taliesin Sisson (<taliesins@yahoo.com>)
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

include_attribute "riak-search::service"
include_attribute "riak-search::package"
include_attribute "riak-search::core"
include_attribute "riak-search::erlang"
include_attribute "riak-search::kv"
include_attribute "riak-search::sasl"
include_attribute "riak-search::err"
include_attribute "riak-search::luwak"

include_attribute "riak-search::merge_index"
include_attribute "riak-search::qilr"
include_attribute "riak-search::riak_search"
include_attribute "riak-search::riak_solr"