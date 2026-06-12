func$ reverse s$ .
   a$[] = strchars s$
   for i = 1 to len a$[] div 2
      swap a$[i] a$[len a$[] - i + 1]
   .
   return strjoin a$[] ""
.
func palin s$ .
   if s$ = reverse s$
      return 1
   .
   return 0
.
func$ lpali st$ .
   for n = 1 to len st$ - 1
      for m = n + 1 to len st$
         sub$ = substr st$ n (m - n)
         if palin sub$ = 1
            if len sub$ > len max$
               max$ = sub$
            .
         .
      .
   .
   return max$
.
for s$ in [ "three old rotators" "never reverse" "stable was I ere I saw elbatrosses" "abracadabra" "drome" "the abbatial palace" ]
   print lpali s$
.
