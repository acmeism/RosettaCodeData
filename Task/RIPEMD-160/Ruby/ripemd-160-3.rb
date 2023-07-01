require 'stringio'

module RMD160
  # functions and constants
  MASK = (1 << 32) - 1
  F = [
    proc {|x, y, z| x ^ y ^ z},
    proc {|x, y, z| (x & y) | (x.^(MASK) & z)},
    proc {|x, y, z| (x | y.^(MASK)) ^ z},
    proc {|x, y, z| (x & z) | (y & z.^(MASK))},
    proc {|x, y, z| x ^ (y | z.^(MASK))},
  ].freeze
  K  = [0x00000000, 0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xa953fd4e]
  KK = [0x50a28be6, 0x5c4dd124, 0x6d703ef3, 0x7a6d76e9, 0x00000000]
  R  = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
        7, 4, 13, 1, 10, 6, 15, 3, 12, 0, 9, 5, 2, 14, 11, 8,
        3, 10, 14, 4, 9, 15, 8, 1, 2, 7, 0, 6, 13, 11, 5, 12,
        1, 9, 11, 10, 0, 8, 12, 4, 13, 3, 7, 15, 14, 5, 6, 2,
        4, 0, 5, 9, 7, 12, 2, 10, 14, 1, 3, 8, 11, 6, 15, 13]
  RR = [5, 14, 7, 0, 9, 2, 11, 4, 13, 6, 15, 8, 1, 10, 3, 12,
        6, 11, 3, 7, 0, 13, 5, 10, 14, 15, 8, 12, 4, 9, 1, 2,
        15, 5, 1, 3, 7, 14, 6, 9, 11, 8, 12, 2, 10, 0, 4, 13,
        8, 6, 4, 1, 3, 11, 15, 0, 5, 12, 2, 13, 9, 7, 10, 14,
        12, 15, 10, 4, 1, 5, 8, 7, 6, 2, 13, 14, 0, 3, 9, 11]
  S  = [11, 14, 15, 12, 5, 8, 7, 9, 11, 13, 14, 15, 6, 7, 9, 8,
        7, 6, 8, 13, 11, 9, 7, 15, 7, 12, 15, 9, 11, 7, 13, 12,
        11, 13, 6, 7, 14, 9, 13, 15, 14, 8, 13, 6, 5, 12, 7, 5,
        11, 12, 14, 15, 14, 15, 9, 8, 9, 14, 5, 6, 8, 6, 5, 12,
        9, 15, 5, 11, 6, 8, 13, 12, 5, 12, 13, 14, 11, 8, 5, 6]
  SS = [8, 9, 9, 11, 13, 15, 15, 5, 7, 7, 8, 11, 14, 14, 12, 6,
        9, 13, 15, 7, 12, 8, 9, 11, 7, 7, 12, 7, 6, 15, 13, 11,
        9, 7, 15, 11, 8, 6, 6, 14, 12, 13, 5, 14, 13, 13, 7, 5,
        15, 5, 8, 11, 14, 14, 6, 14, 6, 9, 12, 9, 12, 5, 15, 8,
        8, 5, 12, 9, 12, 5, 14, 6, 8, 13, 6, 5, 15, 13, 11, 11]

  module_function

  def rol(value, shift)
    (value << shift).&(MASK) | (value.&(MASK) >> (32 - shift))
  end

  # Calculates RIPEMD-160 message digest of _string_. Returns binary
  # digest. For hexadecimal digest, use
  # +*RMD160.rmd160(string).unpack('H*')+.
  def rmd160(string)
    # initial hash
    h0 = 0x67452301
    h1 = 0xefcdab89
    h2 = 0x98badcfe
    h3 = 0x10325476
    h4 = 0xc3d2e1f0

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
        x.push(bit_len & MASK, bit_len >> 32)
        last = true
      else
        fail "impossible"
      end

      # Process this block.
      a,  b,  c,  d,  e  = h0, h1, h2, h3, h4
      aa, bb, cc, dd, ee = h0, h1, h2, h3, h4
      j = 0
      5.times {|ro|
        f, ff = F[ro], F[4 - ro]
        k, kk = K[ro], KK[ro]
        16.times {
          a, e, d, c, b = e, d, rol(c, 10), b,
            rol(a + f[b, c, d] + x[R[j]] + k, S[j]) + e
          aa, ee, dd, cc, bb = ee, dd, rol(cc, 10), bb,
            rol(aa + ff[bb, cc, dd] + x[RR[j]] + kk, SS[j]) + ee
          j += 1
        }
      }
      h0, h1, h2, h3, h4 =
        (h1 + c + dd) & MASK, (h2 + d + ee) & MASK,
        (h3 + e + aa) & MASK, (h4 + a + bb) & MASK,
        (h0 + b + cc) & MASK
    end  # until last

    [h0, h1, h2, h3, h4].pack("V5")
  end
end

if __FILE__ == $0
  # Print an example RIPEMD-160 digest.
  str = 'Rosetta Code'
  printf "%s:\n  %s\n", str, *RMD160.rmd160(str).unpack('H*')
end
