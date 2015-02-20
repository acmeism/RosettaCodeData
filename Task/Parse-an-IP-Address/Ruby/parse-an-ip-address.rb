require 'socket'
require 'ipaddr'

IP_ADDRESSES = ["127.0.0.1",                "127.0.0.1:80",
                "::1",                      "[::1]:80",
                "2605:2700:0:3::4713:93e3", "[2605:2700:0:3::4713:93e3]:80",
                "fe80::1%lo0",              "1600 Pennsylvania Avenue NW"]
output = []
output << %w(String Address Port Family Hex Scope?)
output << %w(------ ------- ---- ------ --- ------)

# Parse _string_ for an IP address and optional port number. Returns
# them in an Addrinfo object.
def parse_addr(string)
  # Split host and port number from string.
  case string
  when /\A\[(?<address> .* )\]:(?<port> \d+ )\z/x      # string like "[::1]:80"
    address, port = $~[:address], $~[:port]
  when /\A(?<address> [^:]+ ):(?<port> \d+ )\z/x       # string like "127.0.0.1:80"
    address, port = $~[:address], $~[:port]
  else                                                 # string with no port number
    address, port = string, nil
  end

  # Pass address, port to Addrinfo.getaddrinfo. It will raise SocketError if address or port is not valid.
  # IPAddr currently cannot handle ::1 notation, use Addrinfo instead
  ary = Addrinfo.getaddrinfo(address, port)

  # An IP address is exactly one address.
  ary.size == 1 or raise SocketError, "expected 1 address, found #{ary.size}"
  ary.first
end

def output_table(rows)
  widths = []
  rows.each {|row| row.each_with_index {|col, i| widths[i] = [widths[i].to_i, col.to_s.length].max }}
  format = widths.map {|size| "%#{size}s"}.join("\t")
  rows.each {|row| puts format % row}
end

family_hash = {Socket::AF_INET => "ipv4", Socket::AF_INET6 => "ipv6"}

IP_ADDRESSES.each do |string|
  begin
    addr = parse_addr(string)
  rescue SocketError
    output << [string, "illegal address", '','','','']
  else
    (cur_string ||= []) << string << addr.ip_address << addr.ip_port.to_s << family_hash[addr.afamily] # for output

    # Show address in hexadecimal. We must unpack it from sockaddr string.
    if addr.ipv4?
      # network byte order "N"
      cur_string << "0x%08x" % IPAddr.new(addr.ip_address).hton.unpack('N') << ""
    elsif addr.ipv6?
      # 32 bytes for address, network byte order "N4"
      cur_string << "0x%032x" % IPAddr.new(addr.ip_address).to_i
      cur_string << (addr.ipv6_linklocal? ? ary[4] : "") # for Scope
    end
    output << cur_string
  end
end

output_table output
