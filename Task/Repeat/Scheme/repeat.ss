(import (scheme base)
        (scheme write))

(define (repeat proc n)
  (do ((i 0 (+ 1 i))
       (res '() (cons (proc) res)))
    ((= i n) res)))

;; example returning an unspecified value
(display (repeat (lambda () (display "hi\n")) 4)) (newline)

;; example returning a number
(display (repeat (lambda () (+ 1 2)) 5)) (newline)
