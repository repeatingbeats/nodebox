maintainer        "Talifun Ltd"
maintainer_email  "taliesins@yahoo.com"
license           "Apache 2.0"
description       "Installs nodejs application as a service"
version           "0.1.0"

recipe "application", "Installs nodejs application as a service"

%w{ ubuntu debian }.each do |os|
  supports os
end
