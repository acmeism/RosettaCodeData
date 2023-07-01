(de q (N)
   (cache '(NIL) N
      (if (>= 2 N)
         1
         (+
            (q (- N (q (dec N))))
            (q (- N (q (- N 2)))) ) ) ) )
