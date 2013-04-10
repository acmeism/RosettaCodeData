(scl 9)
(load "@lib/math.l")

(de cholesky (A)
   (let L (mapcar '(() (need (length A) 0)) A)
      (for (I . R) A
         (for J I
            (let S (get R J)
               (for K (inc J)
                  (dec 'S (*/ (get L I K) (get L J K) 1.0)) )
               (set (nth L I J)
                  (if (= I J)
                     (sqrt (* 1.0 S))
                     (*/ S 1.0 (get L J J)) ) ) ) ) )
      (for R L
         (for N R (prin (align 9 (round N 5))))
         (prinl) ) ) )
