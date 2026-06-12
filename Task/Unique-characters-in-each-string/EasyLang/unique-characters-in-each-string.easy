len d[] 255
for s$ in [ "1a3c52debeffd" "2b6178c97a938stf" "3ycxdb1fgxa2yz" ]
   for c$ in strchars s$
      d[strcode c$] += 1
   .
   for i to 255
      if d[i] = 1
         d[i] = 0
      else
         d[i] = 2
      .
   .
.
for i to 255
   if d[i] = 0
      write strchar i & " "
   .
.
