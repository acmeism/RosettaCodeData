def vl_encode (n)
  raise "negative numbers aren't vl-encodeable" unless n >= 0
  bytes_needed = n == 0 ? 1 : (n.bit_length - 1) // 7 + 1
  bytes = Bytes.new(bytes_needed)
  (0...bytes_needed).reverse_each do |i|
    bytes[i] = (n & 127).to_u8 | 128
    n >>= 7
  end
  bytes[-1] &= 127
  bytes
end

def vl_decode (bytes)
  size = (bytes.size - 1) * 7 + (bytes[0] & 127).bit_length
  n = size > 63 ? 0.to_i128 : size > 31 ? 0.to_i64 : 0
  bytes.reduce(n) {|result, byte| (result << 7) + (byte & 127) }
end

[0x200000, 0x1fffff].each do |n|
  encoded = vl_encode(n)
  decoded = vl_decode(encoded)
  puts "%8d %12s %8d" % { n, encoded.map {|b| "%02x" % b }.join(":"), decoded }
end
