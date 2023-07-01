(define iterate
  PHI N ->
    (let PHI1 (+ 1 (/ 1 PHI))
         N1   (+ N 1)
         DIFF (* 100000 (- PHI1 PHI))
         (if (and (<= -1 DIFF) (<= DIFF 1))
            [PHI1 N1 (- PHI1 1.618033988749895)]
            (iterate PHI1 N1))))

(print (iterate 1 0))
