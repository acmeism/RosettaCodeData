#! /usr/local/bin/newlisp

(define (check-division x y)
    (catch (/ x y) 'check-zero)
    (if (not (integer? check-zero))
        (setq check-zero "Division by zero."))
     check-zero
)

(println (check-division 10 4))
(println (check-division 4 0))
(println (check-division 20 5))
(println (check-division 11 0))

(exit)
