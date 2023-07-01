(import (scheme base)
        (scheme read)
        (scheme write))

;; Read x/y from user
(define x (begin (display "X: ") (flush-output-port) (read)))
(define y (begin (display "Y: ") (flush-output-port) (read)))

;; Create a vector, and fill it with a vector for each row
(define arr (make-vector x))
(do ((i 0 (+ 1 i)))
  ((= i x) )
  (vector-set! arr i (make-vector y 0)))

;; set element (x/2, y/2) to 3
(vector-set! (vector-ref arr (floor (/ x 2)))
             (floor (/ y 2))
             3)

(display arr) (newline)
(display "Retrieved: ")
(display (vector-ref (vector-ref arr (floor (/ x 2)))
                     (floor (/ y 2))))
(newline)
