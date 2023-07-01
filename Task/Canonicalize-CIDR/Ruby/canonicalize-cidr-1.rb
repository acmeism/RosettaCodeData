#!/usr/bin/env ruby

# canonicalize a CIDR block: make sure none of the host bits are set
if ARGV.length == 0 then
    ARGV = $stdin.readlines.map(&:chomp)
end

ARGV.each do |cidr|

  # dotted-decimal / bits in network part
  dotted, size_str = cidr.split('/')
  size = size_str.to_i

  # get IP as binary string
  binary = dotted.split('.').map { |o| "%08b" % o }.join

  # Replace the host part with all zeroes
  binary[size .. -1] = '0' * (32 - size)

  # Convert back to dotted-decimal
  canon = binary.chars.each_slice(8).map { |a| a.join.to_i(2) }.join('.')

  # And output
  puts "#{canon}/#{size}"
end
