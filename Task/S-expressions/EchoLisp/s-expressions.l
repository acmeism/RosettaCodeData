(define input-string #'((data "quoted data" 123 4.5)\n(data (!@# (4.5) "(more" "data)")))'#)

input-string
    → "((data "quoted data" 123 4.5)
    (data (!@# (4.5) "(more" "data)")))"

(define s-expr (read-from-string input-string))
s-expr
    → ((data "quoted data" 123 4.5) (data (!@# (4.5) "(more" "data)")))

(first s-expr)
    → (data "quoted data" 123 4.5)
(first(first s-expr))
    → data
(first(rest s-expr))
    → (data (!@# (4.5) "(more" "data)"))
