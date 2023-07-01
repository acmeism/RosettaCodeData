(for (Max 10  (>= 100000000 Max)  (* Max 10))
   (let (Total 0  Prim 0  In (3 4 5))
      (recur (In)
         (let P (apply + In)
            (when (>= Max P)
               (inc 'Prim)
               (inc 'Total (/ Max P))
               (for Row
                  (quote
                     (( 1 -2 2) ( 2 -1 2) ( 2 -2 3))
                     (( 1  2 2) ( 2  1 2) ( 2  2 3))
                     ((-1  2 2) (-2  1 2) (-2  2 3)) )
                  (recurse
                     (mapcar '((U) (sum * U In)) Row) ) ) ) ) )
      (prinl "Up to " Max ": " Total " triples, " Prim " primitives.") ) )
