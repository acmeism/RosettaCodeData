proc lookandsay . a$ .
   c = 1
   p$ = substr a$ 1 1
   for i = 2 to len a$
      if p$ = substr a$ i 1
         c += 1
      else
         s$ &= c & p$
         p$ = substr a$ i 1
         c = 1
      .
   .
   s$ &= c & p$
   swap a$ s$
.
b$ = 1
print b$
for k = 1 to 10
   lookandsay b$
   print b$
.
