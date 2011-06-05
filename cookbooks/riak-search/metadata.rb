maintainer        "Talifun Ltd"
maintainer_email  "taliesins@yahoo.com"
license           "Apache 2.0"
description       "Setup riak-search"
version           "0.1.0"

recipe "riak-search", "Setup riak-search"

%w{ ubuntu debian }.each do |os|
  supports os
end
