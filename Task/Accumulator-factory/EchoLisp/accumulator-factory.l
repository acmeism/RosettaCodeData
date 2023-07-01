(define-syntax-rule (inc x v) (set! x (+ x v)))
(define (accumulator (sum 0)) (lambda(x) (inc sum x) sum))

(define x (accumulator 1)) → x
(x 5) → 6

;; another closure
(accumulator 3) → (🔒 λ (_x) (📝 #set! sum (#+ sum _x)) sum)

(x 2.3) → 8.3
