func$ order data$ order$ .
   data$[] = strsplit data$ " "
   order$[] = strsplit order$ " "
   for o to len order$[]
      for d to len data$[]
         if order$[o] = data$[d]
            data$[d] = ""
            break 1
         .
      .
   .
   o = 1
   for d to len data$[]
      if data$[d] = ""
         data$[d] = order$[o]
         o += 1
         if o > len order$[]
            break 1
         .
      .
   .
   r$ = data$[1]
   for i = 2 to len data$[]
      r$ &= " " & data$[i]
   .
   return r$
.
tests$[][] = [ [ "the cat sat on the mat" "mat cat" ] [ "the cat sat on the mat" "cat mat" ] [ "A B C A B C A B C" "C A C A" ] [ "A B C A B D A B E" "E A D A" ] [ "A B" "B" ] [ "A B" "B A" ] [ "A B B A" "B A" ] ]
for i to len tests$[][]
   print order tests$[i][1] tests$[i][2]
.
