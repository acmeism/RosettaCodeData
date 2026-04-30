require "socket"

def parse_ip_address (s)
  if m = /^(?:\[(.+)\]|([^:]+))(?::(\d+))?$/.match(s)
    ip6, ip4, port = m[1]?, m[2]?, m[3]?
  else
    ip6 = s
  end
  port = port.to_i if port
  return {nil, nil} if port && !Socket::IPAddress.valid_port?(port)
  hex = if ip6
          Socket::IPAddress.parse_v6_fields?(ip6).try &.map {|i| "%04X" % i }.join
        elsif ip4
          Socket::IPAddress.parse_v4_fields?(ip4).try &.map {|i| "%02X" % i }.join
        end
  { hex, (port if hex) }
end

cases = %w(
    127.0.0.1
    127.0.0.1:80
    ::1
    [::1]:80
    2605:2700:0:3::4713:93e3
    [2605:2700:0:3::4713:93e3]:80
    2001:db8:85a3:0:0:8a2e:370:7334
    2001:db8:85a3::8a2e:370:7334
    [2001:db8:85a3:8d3:1319:8a2e:370:7348]:443
    192.168.0.1
    ::ffff:192.168.0.1
    ::ffff:71.19.147.227
    [::ffff:71.19.147.227]:80
    ::
    256.0.0.0
    g::1
    0000
    0000:0000
    0000:0000:0000:0000:0000:0000:0000:0000
    0000:0000:0000::0000:0000
    0000::0000::0000:0000
    ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
    ffff:ffff:ffff:fffg:ffff:ffff:ffff:ffff
    fff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
    fff:ffff:0:ffff:ffff:ffff:ffff:ffff
)

maxwd = cases.max_of &.size
puts "%-*s  family                               hex  port" % {maxwd, "address"}
puts   "%s------------------------------------------------" % {"-"*maxwd}
cases.each do |addr|
  hex, port = parse_ip_address addr
  puts "%-*s   %s   %32s  %s" % { maxwd, addr,
                                  hex && (hex.size == 8 ? "IPv4" : "IPv6"),
                                  hex || "(bogus address)",
                                  port }
end
