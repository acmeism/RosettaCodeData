(de q (N)
   (cache '(NIL) (pack (char (hash N)) N)
      (if (>= 2 N)
         1
         (+
            (q (- N (q (dec N))))
            (q (- N (q (- N 2)))) ) ) ) )
