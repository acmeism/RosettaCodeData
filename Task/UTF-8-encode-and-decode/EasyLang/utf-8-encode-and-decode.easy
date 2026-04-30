sysconf hex_numbers
func$ utf8dec b[] .
   ind = 1
   while ind <= len b[]
      n = b[ind]
      if n < 0x80
         cnt = 0
      elif n >= 0xf0
         cnt = 3
         n = bitand n 0x7
      elif n >= 0xe0
         cnt = 2
         n = bitand n 0xf
      elif n >= 0xc0
         cnt = 1
         n = bitand n 0x1f
      else
         return ""
      .
      for i = 1 to cnt
         h = b[ind + i]
         if bitand h 0xc0 <> 0x80 : return ""
         h = bitand h 0x3f
         n = n * 64 + h
      .
      ind += cnt + 1
      res$ &= strchar n
   .
   return res$
.
func[] utf8enc s$ .
   for c$ in strchars s$
      c = strcode c$
      if c < 0x80
         cnt = 0
         pre = 0
      elif c < 0x800
         cnt = 1
         pre = 0xc0
      elif c < 0x10000
         cnt = 2
         pre = 0xe0
      elif c < 0x200000
         cnt = 3
         pre = 0xf0
      else
         return [ ]
      .
      for i to cnt + 1 : r[] &= 0
      for i = 0 to cnt - 1
         l = c mod 0x40 + 0x80
         c = c div 0x40
         r[$ - i] = l
      .
      r[$ - i] = c + pre
   .
   return r[]
.
for c$ in [ "A" "ö" "Ж" "€" "𝄞" "你好 😊" ]
   b[] = utf8enc c$
   print c$ & "  ->  " & b[] & "  ->  " & utf8dec b[]
.
