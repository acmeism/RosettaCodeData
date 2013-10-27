(for ([base (in-range 2 (add1 5))])
  (printf "Base ~a: " base)
  (for ([n (in-range 0 10)])
    (printf "~a " (van-der-Corput n base)))
  (newline))

#| Base 2: 0 1/2 1/4 3/4 1/8 5/8 3/8 7/8 1/16 9/16
   Base 3: 0 1/3 2/3 1/9 4/9 7/9 2/9 5/9 8/9 1/27
   Base 4: 0 1/4 1/2 3/4 1/16 5/16 9/16 13/16 1/8 3/8
   Base 5: 0 1/5 2/5 3/5 4/5 1/25 6/25 11/25 16/25 21/25 |#
