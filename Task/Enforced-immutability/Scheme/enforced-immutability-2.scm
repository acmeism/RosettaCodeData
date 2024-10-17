(define-constant fnord 23)
;;
fnord
;; => 23
(+ fnord 5)
;; => 28
(set! fnord 42)
;; => Syntax error: set!: Cannot redefine constant in subform fnord of (set! fnord 42)
