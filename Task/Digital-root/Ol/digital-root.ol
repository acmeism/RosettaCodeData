(define (digital-root num)
   (if (less? num 10)
      num
      (let loop ((num num) (sum 0))
         (if (zero? num)
            (digital-root sum)
            (loop (div num 10) (+ sum (mod num 10)))))))

(print (digital-root 627615))
(print (digital-root 39390))
(print (digital-root 588225))
(print (digital-root 393900588225))
