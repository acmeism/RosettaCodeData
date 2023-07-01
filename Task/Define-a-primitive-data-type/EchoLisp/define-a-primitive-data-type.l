(require 'types)
(require 'math)

;; type defined by a predicate
(define (one-ten? x) (in-interval? x 1 10))
(type One-ten [Integer & one-ten?])

;; OR by an enumeration
(type One-ten [ 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 ])

;; EXPLICIT type checking
;; type-of? returns a Boolean

(type-of? 5 One-ten) → #t
(type-of? 'Albert One-ten) → #f

;; type-check raises an error
(type-check 6 One-ten)  → #t
(type-check 88 One-ten)
⛔ error: One-ten : type-check failure : 88 → 'one-ten?'


;; IMPLICIT type checking
;; declare a function signature
(define (f10 x y) (+ x y))
(signature f10 One-ten -> One-ten -> Integer)

(f10 6 7) → 13
(f10 42 666)
❗ error: One-ten : type-check failure : 42 → 'f10:x'
