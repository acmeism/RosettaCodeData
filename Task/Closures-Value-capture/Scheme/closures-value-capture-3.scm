(define list-of-functions (map (lambda (x) (lambda () (* x x))) (iota 0 1 10)))

; print the result
(display
  (map (lambda (n) (n)) list-of-functions)
(newline)
