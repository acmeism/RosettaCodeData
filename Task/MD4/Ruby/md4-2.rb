require 'stringio'

# Calculates MD4 message digest of _string_. Returns binary digest.
# For hexadecimal digest, use +*md4(str).unpack('H*')+.
def md4(string)
  # functions
  mask = (1 << 32) - 1
  f = proc {|x, y, z| x & y | x.^(mask) & z}
  g = proc {|x, y, z| x & y | x & z | y & z}
  h = proc {|x, y, z| x ^ y ^ z}
  r = proc {|v, s| (v << s).&(mask) | (v.&(mask) >> (32 - s))}

  # initial hash
  a, b, c, d = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476

  bit_len = string.size << 3
  string += "\x80"
  while (string.size % 64) != 56
    string += "\0"
  end
  string = string.force_encoding('ascii-8bit') + [bit_len & mask, bit_len >> 32].pack("V2")

  if string.size % 64 != 0
    fail "failed to pad to correct length"
  end

  io = StringIO.new(string)
  block = ""

  while io.read(64, block)
    x = block.unpack("V16")

    # Process this block.
    aa, bb, cc, dd = a, b, c, d
    [0, 4, 8, 12].each {|i|
      a = r[a + f[b, c, d] + x[i],  3]; i += 1
      d = r[d + f[a, b, c] + x[i],  7]; i += 1
      c = r[c + f[d, a, b] + x[i], 11]; i += 1
      b = r[b + f[c, d, a] + x[i], 19]
    }
    [0, 1, 2, 3].each {|i|
      a = r[a + g[b, c, d] + x[i] + 0x5a827999,  3]; i += 4
      d = r[d + g[a, b, c] + x[i] + 0x5a827999,  5]; i += 4
      c = r[c + g[d, a, b] + x[i] + 0x5a827999,  9]; i += 4
      b = r[b + g[c, d, a] + x[i] + 0x5a827999, 13]
    }
    [0, 2, 1, 3].each {|i|
      a = r[a + h[b, c, d] + x[i] + 0x6ed9eba1,  3]; i += 8
      d = r[d + h[a, b, c] + x[i] + 0x6ed9eba1,  9]; i -= 4
      c = r[c + h[d, a, b] + x[i] + 0x6ed9eba1, 11]; i += 8
      b = r[b + h[c, d, a] + x[i] + 0x6ed9eba1, 15]
    }
    a = (a + aa) & mask
    b = (b + bb) & mask
    c = (c + cc) & mask
    d = (d + dd) & mask
  end

  [a, b, c, d].pack("V4")
end

if __FILE__ == $0
  # Print an example MD4 digest.
  str = 'Rosetta Code'
  printf "%s:\n  %s\n", str, *md4(str).unpack('H*')
end
