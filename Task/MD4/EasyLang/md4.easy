func u32 x .
   return bitand x 0xFFFFFFFF
.
func rol x s .
   left = u32 bitshift x s
   right = bitshift u32 x -(32 - s)
   return bitor left right
.
func F x y z .
   return bitor (bitand x y) (bitand bitnot x z)
.
func G x y z .
   return bitor (bitor (bitand x y) (bitand x z)) (bitand y z)
.
func H x y z .
   return bitxor (bitxor x y) z
.
func le32 b0 b1 b2 b3 .
   return b0 + 256 * b1 + 65536 * b2 + 65536 * 256 * b3
.
func$ word2hex w .
   for k = 0 to 3
      h = w mod 256
      for c in [ h div 16 h mod 16 ]
         c += 48
         if c >= 58 : c += 39
         hex$ &= strchar c
      .
      w = w div 256
   .
   return hex$
.
func[] str2bytes s$ .
   for ch$ in strchars s$ : out[] &= strcode ch$
   return out[]
.
proc md4pad &data[] .
   len8 = len data[] * 8
   data[] &= 0x80
   while len data[] mod 64 <> 56 : data[] &= 0x00
   for i = 1 to 8
      data[] &= len8 mod 256
      len8 = len8 div 256
   .
.
proc md4block &A &B &C &D blk[] .
   for i = 0 to 15
      b0 = blk[i * 4 + 1]
      b1 = blk[i * 4 + 2]
      b2 = blk[i * 4 + 3]
      b3 = blk[i * 4 + 4]
      x[] &= le32 b0 b1 b2 b3
   .
   a = A ; b = B ; c = C ; d = D
   #
   a = rol (a + F b c d + x[1]) 3
   d = rol (d + F a b c + x[2]) 7
   c = rol (c + F d a b + x[3]) 11
   b = rol (b + F c d a + x[4]) 19
   a = rol (a + F b c d + x[5]) 3
   d = rol (d + F a b c + x[6]) 7
   c = rol (c + F d a b + x[7]) 11
   b = rol (b + F c d a + x[8]) 19
   a = rol (a + F b c d + x[9]) 3
   d = rol (d + F a b c + x[10]) 7
   c = rol (c + F d a b + x[11]) 11
   b = rol (b + F c d a + x[12]) 19
   a = rol (a + F b c d + x[13]) 3
   d = rol (d + F a b c + x[14]) 7
   c = rol (c + F d a b + x[15]) 11
   b = rol (b + F c d a + x[16]) 19
   #
   K2 = 0x5A827999
   a = rol (a + G b c d + x[1] + K2) 3
   d = rol (d + G a b c + x[5] + K2) 5
   c = rol (c + G d a b + x[9] + K2) 9
   b = rol (b + G c d a + x[13] + K2) 13
   a = rol (a + G b c d + x[2] + K2) 3
   d = rol (d + G a b c + x[6] + K2) 5
   c = rol (c + G d a b + x[10] + K2) 9
   b = rol (b + G c d a + x[14] + K2) 13
   a = rol (a + G b c d + x[3] + K2) 3
   d = rol (d + G a b c + x[7] + K2) 5
   c = rol (c + G d a b + x[11] + K2) 9
   b = rol (b + G c d a + x[15] + K2) 13
   a = rol (a + G b c d + x[4] + K2) 3
   d = rol (d + G a b c + x[8] + K2) 5
   c = rol (c + G d a b + x[12] + K2) 9
   b = rol (b + G c d a + x[16] + K2) 13
   #
   K3 = 0x6ED9EBA1
   a = rol (a + H b c d + x[1] + K3) 3
   d = rol (d + H a b c + x[9] + K3) 9
   c = rol (c + H d a b + x[5] + K3) 11
   b = rol (b + H c d a + x[13] + K3) 15
   a = rol (a + H b c d + x[3] + K3) 3
   d = rol (d + H a b c + x[11] + K3) 9
   c = rol (c + H d a b + x[7] + K3) 11
   b = rol (b + H c d a + x[15] + K3) 15
   a = rol (a + H b c d + x[2] + K3) 3
   d = rol (d + H a b c + x[10] + K3) 9
   c = rol (c + H d a b + x[6] + K3) 11
   b = rol (b + H c d a + x[14] + K3) 15
   a = rol (a + H b c d + x[4] + K3) 3
   d = rol (d + H a b c + x[12] + K3) 9
   c = rol (c + H d a b + x[8] + K3) 11
   b = rol (b + H c d a + x[16] + K3) 15
   A = u32 (A + a)
   B = u32 (B + b)
   C = u32 (C + c)
   D = u32 (D + d)
.
func$ md4 s$ .
   A = 0x67452301
   B = 0xEFCDAB89
   C = 0x98BADCFE
   D = 0x10325476
   data[] = str2bytes s$
   md4pad data[]
   for b = 0 to len data[] / 64 - 1
      blk[] = [ ]
      for i = 1 to 64 : blk[] &= data[b * 64 + i]
      md4block A B C D blk[]
   .
   digest$ = word2hex A & word2hex B & word2hex C & word2hex D
   return digest$
.
print md4 "Rosetta Code"
