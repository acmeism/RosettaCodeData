func$ sort s$ .
   d$[] = strchars s$
   for i = 1 to len d$[] - 1
      for j = i + 1 to len d$[]
         if strcmp d$[j] d$[i] < 0
            swap d$[j] d$[i]
         .
      .
   .
   return strjoin d$[] ""
.
print sort "The quick brown fox jumps over the lazy dog, apparently"
