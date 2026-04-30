func u32 x .
   return bitand x 0xFFFFFFFF
.
func rol x s .
   left = u32 bitshift x s
   right = bitshift u32 x -(32 - s)
   return bitor left right
.
func be32 b0 b1 b2 b3 .
   return b0 * 16777216 + b1 * 65536 + b2 * 256 + b3
.
func$ word2hex w .
   for k = 0 to 3
      w = rol w 8
      h = w mod 256
      for c in [ h div 16 h mod 16 ]
         c += 48
         if c >= 58 : c += 39
         hex$ &= strchar c
      .
   .
   return hex$
.
func[] str2bytes s$ .
   for ch$ in strchars s$ : out[] &= strcode ch$
   return out[]
.
proc sha1pad &data[] .
   n = len data[] * 8
   data[] &= 0x80
   while len data[] mod 64 <> 56 : data[] &= 0x00
   for i = 1 to 8
      tmp[] &= n mod 256
      n = n div 256
   .
   for i = 1 to 8 : data[] &= tmp[9 - i]
.
proc sha1block &H0 &H1 &H2 &H3 &H4 blk[] .
   for i = 0 to 15
      b0 = blk[i * 4 + 1]
      b1 = blk[i * 4 + 2]
      b2 = blk[i * 4 + 3]
      b3 = blk[i * 4 + 4]
      W[] &= be32 b0 b1 b2 b3
   .
   for t = 17 to 80
      tmp = bitxor W[t - 3] W[t - 8]
      tmp = bitxor tmp W[t - 14]
      tmp = bitxor tmp W[t - 16]
      W[] &= rol u32 tmp 1
   .
   a = H0 ; b = H1 ; c = H2 ; d = H3 ; e = H4
   for t = 1 to 80
      if t <= 20
         f = bitor (bitand b c) (bitand (bitnot b) d)
         K = 0x5A827999
      elif t <= 40
         f = bitxor (bitxor b c) d
         K = 0x6ED9EBA1
      elif t <= 60
         f = bitor (bitor (bitand b c) (bitand b d)) (bitand c d)
         K = 0x8F1BBCDC
      else
         f = bitxor (bitxor b c) d
         K = 0xCA62C1D6
      .
      temp = u32 (rol a 5 + f + e + W[t] + K)
      e = d
      d = c
      c = rol b 30
      b = a
      a = temp
   .
   H0 = u32 (H0 + a)
   H1 = u32 (H1 + b)
   H2 = u32 (H2 + c)
   H3 = u32 (H3 + d)
   H4 = u32 (H4 + e)
.
func$ sha1 s$ .
   H0 = 0x67452301
   H1 = 0xEFCDAB89
   H2 = 0x98BADCFE
   H3 = 0x10325476
   H4 = 0xC3D2E1F0
   data[] = str2bytes s$
   sha1pad data[]
   blocks = len data[] / 64
   for b = 0 to blocks - 1
      blk[] = [ ]
      for i = 1 to 64 : blk[] &= data[b * 64 + i]
      sha1block H0 H1 H2 H3 H4 blk[]
   .
   return word2hex H0 & word2hex H1 & word2hex H2 & word2hex H3 & word2hex H4
.
print sha1 "Rosetta Code"
