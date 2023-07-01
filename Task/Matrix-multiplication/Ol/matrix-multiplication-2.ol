; long version based on recursive cycles
(define (matrix-multiply A B)
   (define m (length A))
   (define n (length (car A)))
   (assert (eq? (length B) n) ===> #true)
   (define q (length (car B)))
   (define (at m x y)
      (lref (lref m x) y))


   (let mloop ((i (- m 1)) (rows #null))
      (if (< i 0)
         rows
         (mloop
            (- i 1)
            (cons
               (let rloop ((j (- q 1)) (r #null))
                  (if (< j 0)
                     r
                     (rloop
                        (- j 1)
                        (cons
                           (let loop ((k 0) (c 0))
                              (if (eq? k n)
                                 c
                                 (loop (+ k 1) (+ c (* (at A i k) (at B k j))))))
                           r))))
               rows)))))
