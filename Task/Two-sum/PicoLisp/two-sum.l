(de twosum (Lst N)
   (for  ((I . A) Lst  A  (cdr A))
      (T
         (for ((J . B) (cdr Lst)  B  (cdr B))
            (T (= N (+ (car A) (car B)))
               (cons I (inc J)) ) )
         @ ) ) )
(println
   (twosum (0 2 11 19 90) 21)
   (twosum (-3 -2 0 1 5 8 11) 17)
   (twosum (-8 -2 -1 1 5 9 11) 0) )
