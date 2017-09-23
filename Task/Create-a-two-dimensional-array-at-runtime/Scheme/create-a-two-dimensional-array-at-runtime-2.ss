(import (except (scheme base) equal?)
        (scheme read)
        (scheme write)
        (srfi 63)       ; an array SRFI
        )

;; Read x/y from user
(define x (begin (display "X: ") (flush-output-port) (read)))
(define y (begin (display "Y: ") (flush-output-port) (read)))

;; Create an array
(define array (make-array #(0) x y))

;; Write to middle element of the array
(array-set! array 3 (floor (/ x 2)) (floor (/ y 2)))

;; Retrieve and display result
(display (array-ref array (floor (/ x 2)) (floor (/ y 2)))) (newline)
