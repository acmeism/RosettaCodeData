   fmt parseaddr '127.0.0.1'
ipv4 7f000001
   fmt parseaddr '127.0.0.1:80'
ipv4 7f000001 80
   fmt parseaddr '::1'
ipv6 1
   fmt parseaddr '[::1]:80'
ipv6 1 80
   fmt parseaddr '2605:2700:0:3::4713:93e3'
ipv6 260527000000000300000000471393e3
   fmt parseaddr '[2605:2700:0:3::4713:93e3]:80'
ipv6 260527000000000300000000471393e3 80
