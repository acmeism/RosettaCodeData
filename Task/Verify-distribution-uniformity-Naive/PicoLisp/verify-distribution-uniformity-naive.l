(de checkDistribution (Cnt Pm . Prg)
   (let Res NIL
      (do Cnt (accu 'Res (run Prg 1) 1))
      (let
         (N (/ Cnt (length Res))
            Min (*/ N (- 1000 Pm) 1000)
            Max (*/ N (+ 1000 Pm) 1000) )
         (for R Res
            (prinl (cdr R) " " (if (>= Max (cdr R) Min) "Good" "Bad")) ) ) ) )
