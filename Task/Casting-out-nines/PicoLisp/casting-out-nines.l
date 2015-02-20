(de kaprekar (N)
   (let L (cons 0 (chop (* N N)))
      (for ((I . R) (cdr L) R (cdr R))
         (NIL (gt0 (format R)))
         (T (= N (+ @ (format (head I L)))) N) ) ) )

(de co9 (N)
   (until
      (> 9
         (setq N
            (sum
               '((N) (unless (= "9" N) (format N)))
               (chop N) ) ) ) )
   N )

(println 'Part1:)
(println
   (=
      (co9 (+ 6395 1259))
      (co9 (+ (co9 6395) (co9 1259))) ) )

(println 'Part2:)
(println
   (filter
      '((N) (= (co9 N) (co9 (* N N))))
      (range 1 100) ) )
(println
   (filter kaprekar (range 1 100)) )

(println 'Part3 '- 'base17:)
(println
   (filter
      '((N) (= (% N 16) (% (* N N) 16)))
      (range 1 100) ) )

(bye)
