;; special fib's starting with 1 2 3 5 ...
(define (fibonacci n)
    (+ (fibonacci (1- n)) (fibonacci (- n 2))))
(remember 'fibonacci #(1 2))

(define-constant Φ (// (1+ (sqrt 5)) 2))
(define-constant logΦ (log Φ))
;; find i : fib(i) >= n
(define (iFib n)
   (floor (// (log (+ (* n Φ) 0.5)) logΦ)))

;; left trim zeroes
(string-delimiter "")
(define (zeck->string digits)
        (if (!= 0 (first digits))
            (string-join digits "")
            (zeck->string (rest digits))))

(define (Zeck n)
        (cond
        (( < n 0) "no negative zeck")
        ((inexact? n) "no floating zeck")
        ((zero? n) "0")
        (else (zeck->string
                (for/list ((s (reverse (take fibonacci (iFib n)))))
                (if ( > s n) 0
                    (begin (-= n s) 1 )))))))
