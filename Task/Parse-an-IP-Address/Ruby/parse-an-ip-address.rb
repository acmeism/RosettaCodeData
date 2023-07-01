require 'ipaddr'


TESTCASES = ["127.0.0.1",                "127.0.0.1:80",
                "::1",                      "[::1]:80",
                "2605:2700:0:3::4713:93e3", "[2605:2700:0:3::4713:93e3]:80"]

output = [%w(String Address Port Family Hex),
          %w(------ ------- ---- ------ ---)]

def output_table(rows)
  widths = []
  rows.each {|row| row.each_with_index {|col, i| widths[i] = [widths[i].to_i, col.to_s.length].max }}
  format = widths.map {|size| "%#{size}s"}.join("\t")
  rows.each {|row| puts format % row}
end

TESTCASES.each do |str|
  case str  # handle port; IPAddr does not.
  when /\A\[(?<address> .* )\]:(?<port> \d+ )\z/x      # string like "[::1]:80"
    address, port = $~[:address], $~[:port]
  when /\A(?<address> [^:]+ ):(?<port> \d+ )\z/x       # string like "127.0.0.1:80"
    address, port = $~[:address], $~[:port]
  else                                                 # string with no port number
    address, port = str, nil
  end

  ip_addr = IPAddr.new(address)
  family = "IPv4" if ip_addr.ipv4?
  family = "IPv6" if ip_addr.ipv6?

  output << [str, ip_addr.to_s, port.to_s, family, ip_addr.to_i.to_s(16)]
end

output_table(output)
