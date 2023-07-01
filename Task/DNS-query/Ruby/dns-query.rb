irb(main):001:0> require 'socket'
=> true
irb(main):002:0> Addrinfo.getaddrinfo("www.kame.net", nil, nil, :DGRAM) \
irb(main):003:0*   .map! { |ai| ai.ip_address }
=> ["203.178.141.194", "2001:200:dff:fff1:216:3eff:feb1:44d7"]
