(define (popcount n)
   (let loop ((n n) (c 0))
      (if (= n 0)
         c
         (loop (>> n 1)
               (if (eq? (band n 1) 0) c (+ c 1))))))
(print (popcount 31415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253))


(define thirty 30)

(display "popcount:")
(for-each (lambda (i)
      (display " ")
      (display (popcount (expt 3 i))))
   (iota thirty 0))
(print)

(define (evenodd name test)
   (display name) (display ":")
   (for-each (lambda (i)
         (display " ")
         (display i))
      (reverse
         (let loop ((n 0) (i 0) (out '()))
            (if (= i thirty)
               out
               (if (test (popcount n))
                  (loop (+ n 1) (+ i 1) (cons n out))
                  (loop (+ n 1) i out))))))
   (print))

(evenodd "evil" even?)
(evenodd "odius" odd?)
