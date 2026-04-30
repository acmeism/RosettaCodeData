func u32 x .
   return bitand x 0xFFFFFFFF
.
func rol x s .
   left = u32 bitshift x s
   right = bitshift u32 x -(32 - s)
   return bitor left right
.
func$ hex w .
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
func fx n x y z .
   if n = 1 : return u32 bitxor (bitxor x y) z
   if n = 2 : return u32 bitor (bitand x y) (bitand bitnot x z)
   if n = 3 : return u32 bitxor (bitor x bitnot y) z
   if n = 4 : return u32 bitor (bitand x z) (bitand y bitnot z)
   return u32 bitxor x (bitor y bitnot z)
.
func[] str2bytes s$ .
   out[] = [ ]
   for ch$ in strchars s$ : out[] &= strcode ch$
   return out[]
.
proc rmd160pad &data[] .
   n = len data[] * 8
   data[] &= 0x80
   while len data[] mod 64 <> 56 : data[] &= 0x00
   for i = 1 to 8
      data[] &= (n mod 256)
      n = n div 256
   .
.
rl[] = [ 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 7 4 13 1 10 6 15 3 12 0 9 5 2 14 11 8 3 10 14 4 9 15 8 1 2 7 0 6 13 11 5 12 1 9 11 10 0 8 12 4 13 3 7 15 14 5 6 2 4 0 5 9 7 12 2 10 14 1 3 8 11 6 15 13 ]
sl[] = [ 11 14 15 12 5 8 7 9 11 13 14 15 6 7 9 8 7 6 8 13 11 9 7 15 7 12 15 9 11 7 13 12 11 13 6 7 14 9 13 15 14 8 13 6 5 12 7 5 11 12 14 15 14 15 9 8 9 14 5 6 8 6 5 12 9 15 5 11 6 8 13 12 5 12 13 14 11 8 5 6 ]
rr[] = [ 5 14 7 0 9 2 11 4 13 6 15 8 1 10 3 12 6 11 3 7 0 13 5 10 14 15 8 12 4 9 1 2 15 5 1 3 7 14 6 9 11 8 12 2 10 0 4 13 8 6 4 1 3 11 15 0 5 12 2 13 9 7 10 14 12 15 10 4 1 5 8 7 6 2 13 14 0 3 9 11 ]
sr[] = [ 8 9 9 11 13 15 15 5 7 7 8 11 14 14 12 6 9 13 15 7 12 8 9 11 7 7 12 7 6 15 13 11 9 7 15 11 8 6 6 14 12 13 5 14 13 13 7 5 15 5 8 11 14 14 6 14 6 9 12 9 12 5 15 8 8 5 12 9 12 5 14 6 8 13 6 5 15 13 11 11 ]
KL[] = [ 0x00000000 0x5A827999 0x6ED9EBA1 0x8F1BBCDC 0xA953FD4E ]
KR[] = [ 0x50A28BE6 0x5C4DD124 0x6D703EF3 0x7A6D76E9 0x00000000 ]
proc rmd160block &H0 &H1 &H2 &H3 &H4 blk[] .
   for i = 0 to 15
      b = 0
      for j = 4 downto 1 : b = b * 256 + blk[i * 4 + j]
      X[] &= b
   .
   a = H0 ; b = H1 ; c = H2 ; d = H3 ; e = H4
   aa = H0 ; bb = H1 ; cc = H2 ; dd = H3 ; ee = H4
   for j = 1 to 80
      rnd = (j - 1) div 16 + 1
      f = fx rnd b c d
      idxL = rl[j] + 1
      T = u32 (a + f + X[idxL] + KL[rnd])
      T = u32 (rol T sl[j] + e)
      a = e ; e = d ; d = rol c 10 ; c = b ; b = T ; h = 6 - rnd
      ff = fx h bb cc dd
      idxR = rr[j] + 1
      TT = u32 (aa + ff + X[idxR] + KR[rnd])
      TT = u32 (rol TT sr[j] + ee)
      aa = ee ; ee = dd ; dd = rol cc 10 ; cc = bb ; bb = TT
   .
   t = u32 (H1 + c + dd)
   H1 = u32 (H2 + d + ee)
   H2 = u32 (H3 + e + aa)
   H3 = u32 (H4 + a + bb)
   H4 = u32 (H0 + b + cc)
   H0 = t
.
func$ ripemd160 s$ .
   H0 = 0x67452301 ; H1 = 0xEFCDAB89 ; H2 = 0x98BADCFE
   H3 = 0x10325476 ; H4 = 0xC3D2E1F0
   data[] = str2bytes s$
   rmd160pad data[]
   blocks = len data[] / 64
   for b = 0 to blocks - 1
      blk[] = [ ]
      for i = 1 to 64 : blk[] &= data[b * 64 + i]
      rmd160block H0 H1 H2 H3 H4 blk[]
   .
   return hex H0 & hex H1 & hex H2 & hex H3 & hex H4
.
print ripemd160 "Rosetta Code"
