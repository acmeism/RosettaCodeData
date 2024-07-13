func[] expand txt$ .
   for r$ in strsplit txt$ ","
      for i = 2 to len r$ - 1
         if substr r$ i 1 = "-"
            a = number substr r$ 1 (i - 1)
            b = number substr r$ (i + 1) 999
            break 1
         .
      .
      if i = len r$
         lst[] &= number r$
      else
         for i = a to b
            lst[] &= i
         .
      .
   .
   return lst[]
.
print expand "-6,-3--1,3-5,7-11,14,15,17-20"
