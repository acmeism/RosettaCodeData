(define (set-cons a A)
    (make-set (cons a A)))

(define (power-set e)
    (cond ((null? e)
       (make-set (list ∅)))
    (else (let [(ps (power-set (cdr e)))]
       (make-set
       (append ps (map set-cons (circular-list (car e)) ps)))))))

(define B (make-set ' ( 🍎 🍇 🎂 🎄 )))
(power-set B)
    → { ∅ { 🍇 } { 🍇 🍎 } { 🍇 🍎 🎂 } { 🍇 🍎 🎂 🎄 } { 🍇 🍎 🎄 } { 🍇 🎂 } { 🍇 🎂 🎄 }
      { 🍇 🎄 } { 🍎 } { 🍎 🎂 } { 🍎 🎂 🎄 } { 🍎 🎄 } { 🎂 } { 🎂 🎄 } { 🎄 } }

;; The Von Neumann universe

(define V0 (power-set null)) ;; null and ∅ are the same
       → { ∅ }
(define V1 (power-set V0))
       → { ∅ { ∅ } }
(define V2 (power-set V1))
       → { ∅ { ∅ } { ∅ { ∅ } } { { ∅ } } }
(define V3 (power-set V2))
       → { ∅ { ∅ } { ∅ { ∅ } } …🔃 )
(length V3) → 16
(define V4 (power-set V3))
(length V4)  → 65536
;; length V5 = 2^65536 : out of bounds


