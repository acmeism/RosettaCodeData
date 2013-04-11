(de f (N)
   (if (=0 N)
      1
      (- N (m (f (dec N)))) ) )

(de m (N)
   (if (=0 N)
      0
      (- N (f (m (dec N)))) ) )
