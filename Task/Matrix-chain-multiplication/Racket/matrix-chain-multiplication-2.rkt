(define-syntax-rule (echo <x> ...)
  (begin (printf "~a: ~a\n" (~a (quote <x>) #:min-width 12) <x>) ...))

(define (solve input)
  (match-define-values ((list ($ cost explanation)) _ time _) (time-apply compute (list input)))
  (echo input time cost explanation)
  (newline))

(solve #(1 5 25 30 100 70 2 1 100 250 1 1000 2))
(solve #(1000 1 500 12 1 700 2500 3 2 5 14 10))
