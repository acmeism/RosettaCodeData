require 'stringio'

# Calculates SHA-1 message digest of _string_. Returns binary digest.
# For hexadecimal digest, use +*sha1(string).unpack('H*')+.
#--
# This is a simple, pure-Ruby implementation of SHA-1, following
# the algorithm in FIPS 180-1.
#++
def sha1(string)
  # functions and constants
  mask = (1 << 32) - 1        # ffffffff
  s = proc{|n, x| ((x << n) & mask) | (x >> (32 - n))}
  f = [
    proc {|b, c, d| (b & c) | (b.^(mask) & d)},
    proc {|b, c, d| b ^ c ^ d},
    proc {|b, c, d| (b & c) | (b & d) | (c & d)},
    proc {|b, c, d| b ^ c ^ d},
  ].freeze
  k = [0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xca62c1d6].freeze

  # initial hash
  h = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0]

  io = StringIO.new(string)
  block = ""
  term = false  # appended "\x80" in second-last block?
  last = false  # last block?
  until last
    # Read next block of 16 words (64 bytes, 512 bits).
    io.read(64, block) or (
      # Work around a bug in Rubinius 1.2.4. At eof,
      # MRI and JRuby already replace block with "".
      block.clear
    )

    # Unpack block into 32-bit words "N".
    case len = block.length
    when 64
      # Unpack 16 words.
      w = block.unpack("N16")
    when 56..63
      # Second-last block: append padding, unpack 16 words.
      block.concat("\x80"); term = true
      block.concat("\0" * (63 - len))
      w = block.unpack("N16")
    when 0..55
      # Last block: append padding, unpack 14 words.
      block.concat(term ? "\0" : "\x80")
      block.concat("\0" * (55 - len))
      w = block.unpack("N14")

      # Append bit length, 2 words.
      bit_len = string.length << 3
      w.push(bit_len >> 32, bit_len & mask)
      last = true
    else
      fail "impossible"
    end

    # Process block.
    (16..79).each {|t| w[t] = s[1, w[t-3] ^ w[t-8] ^ w[t-14] ^ w[t-16]]}

    a, b, c, d, e = h
    t = 0
    4.times do |i|
      20.times do
        temp = (s[5, a] + f[i][b, c, d] + e + w[t] + k[i]) & mask
        a, b, c, d, e = temp, a, s[30, b], c, d
        t += 1
      end
    end

    [a,b,c,d,e].each_with_index {|x,i| h[i] = (h[i] + x) & mask}
  end

  h.pack("N5")
end

if __FILE__ == $0
  # Print some example SHA-1 digests.
  # FIPS 180-1 has correct digests for 'abc' and 'abc...opq'.
  [ 'abc',
    'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq',
    'Rosetta Code',
  ].each {|s| printf("%s:\n  %s\n", s, *sha1(s).unpack('H*'))}
end
