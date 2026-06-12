proc sort &ar$[] .
   for a$ in ar$[] : k[] &= len a$
   for i = 1 to len k[] - 1
      for j = i + 1 to len k[]
         if k[j] < k[i]
            swap k[j] k[i]
            swap ar$[j] ar$[i]
         .
      .
   .
.
ar$[] = [ "Rosetta" "Code" "is" "a" "programming" "chrestomathy" "site" ]
sort ar$[]
print ar$[]
