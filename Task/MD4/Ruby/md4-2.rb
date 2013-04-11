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

  io = StringIO.new(string)
  block = ""
  term = false  # appended "\x80" in second-last block?
  last = false  # last block?
  until last
    # Read next block of 16 words (64 bytes, 512 bits).
    io.read(64, block) or (
      # Work around a bug in Rubinius 1.2.4. At eof,
      # MRI and JRuby already replace block with "".
      block.replace("")
    )

    # Unpack block into 32-bit words "V".
    case len = block.length
    when 64
      # Unpack 16 words.
      x = block.unpack("V16")
    when 56..63
      # Second-last block: append padding, unpack 16 words.
      block.concat("\x80"); term = true
      block.concat("\0" * (63 - len))
      x = block.unpack("V16")
    when 0..55
      # Last block: append padding, unpack 14 words.
      block.concat(term ? "\0" : "\x80")
      block.concat("\0" * (55 - len))
      x = block.unpack("V14")

      # Append bit length, 2 words.
      bit_len = string.length << 3
      x.push(bit_len & mask, bit_len >> 32)
      last = true
    else
      fail "impossible"
    end

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
