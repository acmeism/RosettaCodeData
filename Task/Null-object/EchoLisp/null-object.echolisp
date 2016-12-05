null → null
() → null
(null? 3) → #f
(!null? 4) → #t
(null? null) → #t

;; careful - null is not false :
(if null 'OUI 'NON) → OUI

;; usual usage : recursion on lists until (null? list)
(define (f list)
    (when (!null? list)
    (write (first list)) (f (rest list))))

(f '( a b c))  →  a b c
