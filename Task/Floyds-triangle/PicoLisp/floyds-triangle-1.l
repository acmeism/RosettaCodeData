(de floyd (N)
   (let LLC (/ (* N (dec N)) 2)
      (for R N
         (for C R
            (prin
               (align
                  (length (+ LLC C))
                  (+ C (/ (* R (dec R)) 2)) ) )
            (if (= C R) (prinl) (space)) ) ) ) )
