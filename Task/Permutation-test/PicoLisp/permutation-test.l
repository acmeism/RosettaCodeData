(load "@lib/simul.l")  # For 'subsets'

(scl 2)

(de _stat (A)
   (let (LenA (length A)  SumA (apply + A))
      (-
         (*/ SumA LenA)
         (*/ (- SumAB SumA) (- LenAB LenA)) ) ) )

(de permutationTest (A B)
   (let
      (AB (append A B)
         SumAB (apply + AB)
         LenAB (length AB)
         Tobs (_stat A)
         Count 0 )
      (*/
         (sum
            '((Perm)
               (inc 'Count)
               (and (>= Tobs (_stat Perm)) 1) )
            (subsets (length A) AB) )
         100.0
         Count ) ) )

(setq
   *TreatmentGroup (0.85 0.88 0.75 0.66 0.25 0.29 0.83 0.39 0.97)
   *ControlGroup   (0.68 0.41 0.10 0.49 0.16 0.65 0.32 0.92 0.28 0.98) )

(let N (permutationTest *TreatmentGroup *ControlGroup)
   (prinl "under = " (round N) "%, over = " (round (- 100.0 N)) "%") )
