(require "comm")
(comm:ip-address-string (comm:get-host-entry "www.rosettacode.org" :fields '(:address)))
"104.28.10.103"
