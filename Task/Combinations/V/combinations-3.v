[comb
   [2dup [a b : a b a b] view].
   [2pop pop pop].

   [ [pop zero?] [2pop [[]]]
     [null?] [2pop []]
     [true] [2dup [pred] dip uncons swapd comb [cons] map popd rollup rest comb concat]
   ] when].
