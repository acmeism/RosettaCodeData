;; 1)
;; a macro will do it, as shown in Racket (same syntax)
(define-syntax-rule (swap a b)
    (let ([tmp a])
    (set! a b)
    (set! b tmp)))

(define A 666)
(define B "simon")
(swap A B)
A → "simon"
B → 666

;; 2)
;; The list-swap! function allows to swap two items inside a list, regardless of their types
;; This physically alters the list

(define L ' ( 1 2 3 4 🎩 ))
(list-swap! L 1 ' 🎩 )
    → (🎩 2 3 4 1)
