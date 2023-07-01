(define (repeat f n) (for ((i n)) (f)))

(repeat (lambda () (write (random 1000))) 5)
    → 287 798 930 989 794

;; Remark
;; It is also possible to iterate a function : f(f(f(f( ..(f x)))))
(define cos10 (iterate cos 10)
(define cos100 (iterate cos10 10))
(cos100 0.6)
    →  0.7390851332151605
(cos 0.7390851332151605)
    → 0.7390851332151608 ;; fixed point found
