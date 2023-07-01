(define (eval-with-x prog x)
    (eval prog (environment-new (list (list 'x x)))))

(define prog '( + 1 (* x x)))

(eval-with-x prog 10) → 101
(eval-with-x prog 1000) → 1000001
(- (eval-with-x prog 1000) (eval-with-x prog 10)) → 999900

;; check x is unbound (no global)
x
😖️ error: #|user| : unbound variable : x
