(de bino (N K)
   (let f
      '((N)
         (if (=0 N) 1 (apply * (range 1 N))) )
      (/
         (f N)
         (* (f (- N K)) (f K)) ) ) )

(for N 15
  (println
     (-
        (bino (* 2 N) N)
        (bino (* 2 N) (inc N)) ) ) )
(bye)
