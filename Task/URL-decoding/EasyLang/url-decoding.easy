func fromhex s$ .
   n = number ("0x" & s$)
   if error = 1 : return -1
   return n
.
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
func$ url2decode s$ .
   c$[] = strchars s$
   lng = len c$[]
   ind = 1
   while ind < lng
      if c$[ind] = "%"
         b[] = [ ]
         while ind <= lng and c$[ind] = "%"
            if ind + 2 > lng : return ""
            n = fromhex (c$[ind + 1] & c$[ind + 2])
            if n = -1 : return ""
            b[] &= n
            ind += 3
         .
         res$ &= utf8dec b[]
      else
         res$ &= c$[ind]
         ind += 1
      .
   .
   return res$
.
print url2decode "https%3A%2F%2Fbn%2Ewikipedia%2Eorg%2Fwiki%2F%E0%A6%B0%E0%A7%8B%E0%A6%B8%E0%A7%87%E0%A6%9F%E0%A6%BE%5F%E0%A6%95%E0%A7%8B%E0%A6%A1"
