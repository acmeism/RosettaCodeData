(lib 'match) ;; reader-infix macros

(reader-infix '∈ )
(reader-infix '∩ )
(reader-infix '∪ )
(reader-infix '⊖ ) ;; set difference

(define-syntax-rule (∈ x a) (a x))
(define-syntax-rule (∩ a b) (lambda(x) (and ( a x) (b x))))
(define-syntax-rule (∪ a b) (lambda(x) (or ( a x) (b x))))
(define-syntax-rule (⊖ a b) (lambda(x) (and ( a x) (not (b x)))))

;; predicates to define common sets
(define (∅ x) #f) ;; the empty set predicate
(define (Z x) (integer? x))
(define (N x) (and (Z x) (>= x 0)))
(define (Q x) (rational? x))
(define (ℜ x) #t)

;; predicates to define convex sets
(define (⟦...⟧ a b)(lambda(x) (and (>= x a) (<= x b))))
(define (⟦...⟦ a b)(lambda(x) (and (>= x a) (< x b))))
(define (⟧...⟧ a b)(lambda(x) (and (> x a) (<= x b))))
(define (⟧...⟦ a b)(lambda(x) (and (> x a) (< x b))))
