(import (scheme base)
        (scheme write)
        (srfi 1))

;; uses n-step sequence formula to
;; continue lst until of length num
(define (n-fib lst num)
  (let ((n (length lst)))
    (do ((result (reverse lst)
                 (cons (fold + 0 (take result n))
                       result)))
      ((= num (length result)) (reverse result)))))

;; display examples
(do ((i 2 (+ 1 i)))
  ((> i 4) )
  (display (string-append "n = "
                          (number->string i)
                          ": "))
  (display (n-fib (cons 1 (list-tabulate (- i 1) (lambda (n) (expt 2 n))))
                  15))
  (newline))

(display "Lucas: ")
(display (n-fib '(2 1) 15))
(newline)
