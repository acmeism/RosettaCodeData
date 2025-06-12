len md5k[] 64
proc md5init .
   for i = 1 to 64
      md5k[i] = floor (0x100000000 * abs sin (i * 180 / pi))
   .
.
md5init
#
func$ md5 inp$ .
   subr addinp
      if inp4 = 1
         inp[] &= 0
      .
      inp[len inp[]] += b * inp4
      inp4 *= 0x100
      if inp4 = 0x100000000
         inp4 = 1
      .
   .
   s[] = [ 7 12 17 22 7 12 17 22 7 12 17 22 7 12 17 22 5 9 14 20 5 9 14 20 5 9 14 20 5 9 14 20 4 11 16 23 4 11 16 23 4 11 16 23 4 11 16 23 6 10 15 21 6 10 15 21 6 10 15 21 6 10 15 21 ]
   inp[] = [ ]
   inp4 = 1
   for i = 1 to len inp$
      b = strcode substr inp$ i 1
      addinp
   .
   b = 0x80
   addinp
   while len inp[] mod 16 <> 14 or inp4 <> 1
      b = 0
      addinp
   .
   h = len inp$ * 8
   for i = 1 to 4
      b = h mod 0x100
      addinp
      h = h div 0x100
   .
   inp[] &= 0
   #
   a0 = 0x67452301
   b0 = 0xefcdab89
   c0 = 0x98badcfe
   d0 = 0x10325476
   for chunk = 1 step 16 to len inp[] - 15
      a = a0 ; b = b0 ; c = c0 ; d = d0
      for i = 1 to 64
         if i <= 16
            h1 = bitand b c
            h2 = bitand bitnot b d
            f = bitor h1 h2
            g = i - 1
         elif i <= 32
            h1 = bitand d b
            h2 = bitand bitnot d c
            f = bitor h1 h2
            g = (5 * i - 4) mod 16
         elif i <= 48
            h1 = bitxor b c
            f = bitxor h1 d
            g = (3 * i + 2) mod 16
         else
            h1 = bitor b bitand bitnot d 0xffffffff
            f = bitxor c h1
            g = (7 * i - 7) mod 16
         .
         f = bitand (f + a + md5k[i] + inp[chunk + g]) 0xffffffff
         a = d
         d = c
         c = b
         h1 = bitshift f s[i]
         h2 = bitshift f (s[i] - 32)
         b = bitand (b + h1 + h2) 0xffffffff
      .
      a0 += a ; b0 += b ; c0 += c ; d0 += d
   .
   for a in [ a0 b0 c0 d0 ]
      for i = 1 to 4
         b = a mod 256
         a = a div 256
         for h in [ b div 16 b mod 16 ]
            h += 48
            if h > 57
               h += 39
            .
            s$ &= strchar h
         .
      .
   .
   return s$
.
repeat
   s$ = input
   until error = 1
   print md5 s$
.
input_data

a
abc
message digest
abcdefghijklmnopqrstuvwxyz
ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
12345678901234567890123456789012345678901234567890123456789012345678901234567890
