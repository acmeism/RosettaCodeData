(seed (time))

(scl 8)

(de statistics (Cnt . Prg)
   (prinl Cnt " numbers")
   (let (Sum 0  Sqr 0  Hist (need 10 NIL 0))
      (do Cnt
         (let N (run Prg 1)  # Get next number
            (inc 'Sum N)
            (inc 'Sqr (*/ N N 1.0))
            (inc (nth Hist (inc (/ N 0.1)))) ) )
      (let M (*/ Sum Cnt)
         (prinl "Mean:   " (round M))
         (prinl "StdDev: "
            (round
               (sqrt
                  (- (*/ Sqr Cnt) (*/ M M 1.0))
                  1.0 ) ) ) )
      (for (I . H) Hist
         (prin (format I 1) " ")
         (do (*/ H 400 Cnt) (prin '=))
         (prinl) ) ) )

(for I (2 4 6)
   (statistics (** 10 I)
      (rand 0 (dec 1.0)) )
   (prinl) )
