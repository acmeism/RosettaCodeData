(de findRoots (F Start Stop Step Eps)
   (filter
      '((N) (> Eps (abs (F N))))
      (range Start Stop Step) ) )

(scl 12)

(mapcar round
   (findRoots
      '((X) (+ (*/ X X X `(* 1.0 1.0)) (*/ -3 X X 1.0) (* 2 X)))
      -1.0 3.0 0.0001 0.00000001 ) )
