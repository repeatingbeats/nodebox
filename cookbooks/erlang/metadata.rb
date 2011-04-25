maintainer        "Talifun Ltd"
maintainer_email  "taliesins@yahoo.com"
license           "Apache 2.0"
description       "Installs erlang from source"
version           "0.1.0"

recipe "erlang", "Installs erlang"

%w{ ubuntu debian }.each do |os|
  supports os
end
