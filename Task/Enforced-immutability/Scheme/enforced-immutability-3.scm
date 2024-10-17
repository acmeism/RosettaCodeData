(define-constant square (lambda (n) (* n n)))
;;
square
;; => #<procedure square>
(square 5)
;; => 25
(set! square (lambda (n) (* n n n)))
;; => Syntax error: set!: Cannot redefine constant in subform square of (set! square (lambda (n) (* n n n)))
