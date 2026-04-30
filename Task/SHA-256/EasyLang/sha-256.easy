func u32 x .
   return bitand x 0xFFFFFFFF
.
func rol x s .
   left = u32 bitshift x s
   right = bitshift u32 x -(32 - s)
   return bitor left right
.
func rotr x s .
   return rol x (32 - s)
.
func sigm1 x .
   a1 = rotr x 2
   a2 = rotr x 13
   r = bitxor a1 a2
   r = bitxor r rotr x 22
   return r
.
func sigm2 x .
   a1 = rotr x 6
   a2 = rotr x 11
   r = bitxor a1 a2
   r = bitxor r rotr x 25
   return r
.
func sigm3 x .
   a1 = rotr x 7
   a2 = rotr x 18
   r = bitxor a1 a2
   r = bitxor r bitshift x -3
   return r
.
func sigm4 x .
   a1 = rotr x 17
   a2 = rotr x 19
   r = bitxor a1 a2
   r = bitxor r bitshift x -10
   return r
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
proc sha256pad &data[] .
   n = len data[] * 8
   data[] &= 0x80
   while len data[] mod 64 <> 56 : data[] &= 0x00
   for i = 1 to 8
      tmp[] &= (n mod 256)
      n = n div 256
   .
   for i = 1 to 8 : data[] &= tmp[9 - i]
.
K[] = [ 0x428A2F98 0x71374491 0xB5C0FBCF 0xE9B5DBA5 0x3956C25B 0x59F111F1 0x923F82A4 0xAB1C5ED5 0xD807AA98 0x12835B01 0x243185BE 0x550C7DC3 0x72BE5D74 0x80DEB1FE 0x9BDC06A7 0xC19BF174 0xE49B69C1 0xEFBE4786 0x0FC19DC6 0x240CA1CC 0x2DE92C6F 0x4A7484AA 0x5CB0A9DC 0x76F988DA 0x983E5152 0xA831C66D 0xB00327C8 0xBF597FC7 0xC6E00BF3 0xD5A79147 0x06CA6351 0x14292967 0x27B70A85 0x2E1B2138 0x4D2C6DFC 0x53380D13 0x650A7354 0x766A0ABB 0x81C2C92E 0x92722C85 0xA2BFE8A1 0xA81A664B 0xC24B8B70 0xC76C51A3 0xD192E819 0xD6990624 0xF40E3585 0x106AA070 0x19A4C116 0x1E376C08 0x2748774C 0x34B0BCB5 0x391C0CB3 0x4ED8AA4A 0x5B9CCA4F 0x682E6FF3 0x748F82EE 0x78A5636F 0x84C87814 0x8CC70208 0x90BEFFFA 0xA4506CEB 0xBEF9A3F7 0xC67178F2 ]
proc sha256block &H0 &H1 &H2 &H3 &H4 &H5 &H6 &H7 blk[] .
   W[] = [ ] ; len W[] 64
   for i = 0 to 15
      b0 = blk[i * 4 + 1] ; b1 = blk[i * 4 + 2]
      b2 = blk[i * 4 + 3] ; b3 = blk[i * 4 + 4]
      W[i + 1] = be32 b0 b1 b2 b3
   .
   for t = 17 to 64
      s0 = sigm3 W[t - 15]
      s1 = sigm4 W[t - 2]
      W[t] = u32 (W[t - 16] + s0 + W[t - 7] + s1)
   .
   a = H0 ; b = H1 ; c = H2 ; d = H3 ; e = H4 ; f = H5 ; g = H6 ; h = H7
   for t = 1 to 64
      ch = bitxor (bitand e f) (bitand (bitnot e) g)
      T1 = u32 (h + sigm2 e + ch + K[t] + W[t])
      h = bitxor (bitand a b) (bitand a c)
      maj = bitxor h (bitand b c)
      T2 = u32 (sigm1 a + maj)
      h = g
      g = f
      f = e
      e = u32 (d + T1)
      d = c
      c = b
      b = a
      a = u32 (T1 + T2)
   .
   H0 = u32 (H0 + a)
   H1 = u32 (H1 + b)
   H2 = u32 (H2 + c)
   H3 = u32 (H3 + d)
   H4 = u32 (H4 + e)
   H5 = u32 (H5 + f)
   H6 = u32 (H6 + g)
   H7 = u32 (H7 + h)
.
func$ sha256 s$ .
   H0 = 0x6A09E667
   H1 = 0xBB67AE85
   H2 = 0x3C6EF372
   H3 = 0xA54FF53A
   H4 = 0x510E527F
   H5 = 0x9B05688C
   H6 = 0x1F83D9AB
   H7 = 0x5BE0CD19
   data[] = str2bytes s$
   sha256pad data[]
   blocks = len data[] / 64
   for b = 0 to blocks - 1
      blk[] = [ ]
      for i = 1 to 64 : blk[] &= data[b * 64 + i]
      sha256block H0 H1 H2 H3 H4 H5 H6 H7 blk[]
   .
   return word2hex H0 & word2hex H1 & word2hex H2 & word2hex H3 & word2hex H4 & word2hex H5 & word2hex H6 & word2hex H7
.
print sha256 "Rosetta code"
