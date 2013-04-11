(load "@lib/simul.l")  # For 'permute'

(de derangements (Lst)
   (filter
      '((L) (not (find = L Lst)))
      (permute Lst) ) )

(de subfact (N)
   (if (>= 2 N)
      (if (= 1 N) 0 1)
      (*
         (dec N)
         (+ (subfact (dec N)) (subfact (- N 2))) ) ) )
