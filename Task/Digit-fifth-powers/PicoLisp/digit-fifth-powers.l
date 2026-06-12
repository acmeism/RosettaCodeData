(de sum5th (N)
   (sum
      '((D) (** (format D) 5))
      (chop N)))

(setq solutions
   (cdr  # exclude 1
      (make
         (for N `(* 6 (** 9 5))
            (when (= N (sum5th N))
               (link N))))))

(prinl "The numbers that can be written as the sum of the 5th power of their digits are:" )
(prin "     ") (println solutions)
(prinl "Their sum is " (apply + solutions))
(bye)
