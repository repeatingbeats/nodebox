maintainer        "Talifun Ltd"
maintainer_email  "taliesins@yahoo.com"
license           "Apache 2.0"
description       "Sets apt-get to use a shared archive folder"
version           "0.1.0"

recipe "apt-get", "Sets apt-get to use a shared archive folder"

%w{ ubuntu debian }.each do |os|
  supports os
end
