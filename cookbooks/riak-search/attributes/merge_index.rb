#
# Author:: Taliesin Sisson (<taliesins@yahoo.com>)
# Cookbook Name:: riaksearch
#
# Copyright (c) 2011 Talifun Ltd.
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

default.riak_search.merge_index.data_root = "/var/lib/riaksearch/merge_index"
default.riak_search.merge_index.buffer_rollover_size = 1048576
default.riak_search.merge_index.buffer_delayed_write_size = 524288
default.riak_search.merge_index.buffer_delayed_write_ms = 2000
default.riak_search.merge_index.max_compact_segments = 20
default.riak_search.merge_index.fold_batch_size = 100
default.riak_search.merge_index.segment_query_read_ahead_size = 65536
default.riak_search.merge_index.segment_compaction_read_ahead_size = 5242880
default.riak_search.merge_index.segment_file_buffer_size = 20971520
default.riak_search.merge_index.segment_delayed_write_size = 20971520
default.riak_search.merge_index.segment_delayed_write_ms = 10000
default.riak_search.merge_index.segment_full_read_size = 5242880
default.riak_search.merge_index.segment_block_size = 32767
default.riak_search.merge_index.segment_values_staging_size = 1000
default.riak_search.merge_index.segment_values_compression_threshold = 0
default.riak_search.merge_index.segment_values_compression_level = 1
