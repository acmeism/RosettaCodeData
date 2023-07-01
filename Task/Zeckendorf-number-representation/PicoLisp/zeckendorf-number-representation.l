(de fib (N)
   (let Fibs (1 1)
      (while (>= N (+ (car Fibs) (cadr Fibs)))
         (push 'Fibs (+ (car Fibs) (cadr Fibs))) )
      (uniq Fibs) ) )

(de zecken1 (N)
   (make
      (for I (fib N)
         (if (> I N)
            (link 0)
            (link 1)
            (dec 'N I) ) ) ) )

(de zecken2 (N)
   (make
      (when (=0 N) (link 0))
      (for I (fib N)
         (when (<= I N)
            (link I)
            (dec 'N I) ) ) ) )

(for (N 0 (> 21 N) (inc N))
   (tab (2 4 6 2 -10)
      N
      " -> "
      (zecken1 N)
      "  "
      (glue " + " (zecken2 N)) ) )

(bye)
