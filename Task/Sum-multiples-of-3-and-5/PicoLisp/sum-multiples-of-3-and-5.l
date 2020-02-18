(de sumMul (N F)
   (let N1 (/ (dec N) F)
      (*/ F N1 (inc N1) 2) ) )

(for I 20
   (let N (** 10 I)
      (println
         (-
            (+ (sumMul N 3) (sumMul N 5))
            (sumMul N 15) ) ) ) )
