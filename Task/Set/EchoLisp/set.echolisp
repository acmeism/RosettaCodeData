; use { } to read a set
(define A { 1 2 3 4 3 5 5}) → { 1 2 3 4 5 } ; duplicates are removed from a set
; or use make-set to make a set from a list
(define B (make-set ' ( 3 4 5 6 7 8 8))) → { 3 4 5 6 7 8 }
(set-intersect A B) → { 3 4 5 }
(set-intersect? A B) → #t ; predicate
(set-union A B) → { 1 2 3 4 5 6 7 8 }
(set-substract A B) → { 1 2 }
(set-sym-diff A B) → { 1 2 6 7 8 } ; ∆ symmetric difference
(set-equal? A B) →  #f
(set-equal? { a b c} { c b a}) → #t ; order is unimportant
(set-subset? A B) → #f ; B in A or B = A
(set-subset? A { 3 4 }) → #t
(member 4 A) → (4 5) ; same as #t : true
(member 9 A) → #f

; check basic equalities
(set-equal? A (set-union (set-intersect A B) (set-substract A B))) → #t
(set-equal? (set-union A B) (set-union (set-sym-diff A B) (set-intersect A B))) → #t

; × : cartesian product of two sets : all pairs (a . b) , a in A, b in B
; returns a list (not a set)
(define A { albert simon})
(define B { antoinette ornella marylin})

(set-product A B)
→ ((albert . antoinette) (albert . marylin) (albert . ornella) (simon . antoinette) (simon . marylin) (simon . ornella))

; sets elements may be sets
{ { a b c} {c b a } { a b d}} → { { a b c } { a b d } } ; duplicate removed

; A few functions return sets :
(primes 10) → { 2 3 5 7 11 13 17 19 23 29 }
