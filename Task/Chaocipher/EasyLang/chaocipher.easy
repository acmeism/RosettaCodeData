func index a$[] c$ .
   for ind = 1 to len a$[]
      if a$[ind] = c$ : return ind
   .
   return 0
.
left$ = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
right$ = "PTLNBQDEOYSFAVZKGJRIHWXUMC"
#
func$ chao txt$ mode .
   left$[] = strchars left$
   right$[] = strchars right$
   len tmp$[] 26
   for c$ in strchars txt$
      if mode = 1
         ind = index right$[] c$
         if ind = 0 : return ""
         r$ &= left$[ind]
      else
         ind = index left$[] c$
         if ind = 0
            print c$
            return ""
         .
         r$ &= right$[ind]
      .
      # permute left
      for j = ind to 26
         tmp$[j - ind + 1] = left$[j]
      .
      for j = 1 to ind - 1
         tmp$[26 - ind + j + 1] = left$[j]
      .
      h$ = tmp$[2]
      for j = 3 to 14
         tmp$[j - 1] = tmp$[j]
      .
      tmp$[14] = h$
      swap tmp$[] left$[]
      #
      # permute right
      for j = ind to 26
         tmp$[j - ind + 1] = right$[j]
      .
      for j = 1 to ind - 1
         tmp$[26 - ind + j + 1] = right$[j]
      .
      h$ = tmp$[1]
      for j = 2 to 26
         tmp$[j - 1] = tmp$[j]
      .
      tmp$[26] = h$
      h$ = tmp$[3]
      for j = 4 to 14
         tmp$[j - 1] = tmp$[j]
      .
      tmp$[14] = h$
      swap tmp$[] right$[]
   .
   return r$
.
h$ = chao "WELLDONEISBETTERTHANWELLSAID" 1
print h$
print chao h$ 2
