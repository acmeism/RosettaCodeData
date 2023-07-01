local socket = require('socket')
local ip_tbl = socket.dns.getaddrinfo('www.kame.net')

for _, v in ipairs(ip_tbl) do
  io.write(string.format('%s: %s\n', v.family, v.addr))
end
