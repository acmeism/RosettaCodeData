fun comb (0, _    ) = [[]]
  | comb (_, []   ) = []
  | comb (m, x::xs) = map (fn y => x :: y) (comb (m-1, xs)) @
                  comb (m, xs)
;
comb (3, [0,1,2,3,4]);
