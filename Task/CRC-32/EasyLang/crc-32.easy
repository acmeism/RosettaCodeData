func crc32 buf$[] .
   for i = 0 to 0xff
      rem = i
      for j to 8
         if bitand rem 1 = 1
            rem = bitxor bitshift rem -1 0xedb88320
         else
            rem = bitshift rem -1
         .
      .
      table[] &= rem
   .
   crc = 0xffffffff
   for c$ in buf$[]
      c = strcode c$
      crb = bitxor bitand crc 0xff c
      crc = bitxor (bitshift crc -8) table[crb + 1]
   .
   return bitnot crc
.
s$ = "The quick brown fox jumps over the lazy dog"
print crc32 strchars s$
