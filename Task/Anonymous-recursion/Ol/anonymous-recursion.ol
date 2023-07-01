(define (fibonacci n)
   (if (> 0 n)
      "error: negative argument."
      (let loop ((a 1) (b 0) (count n))
         (if (= count 0)
            b
            (loop (+ a b) a (- count 1))))))

(print
   (map fibonacci '(1 2 3 4 5 6 7 8 9 10)))
