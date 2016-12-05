(define-syntax-rule (make-h-var name) (define name (stack (gensym))))
(define-syntax-rule (h-get name) (stack-top name))
(define-syntax-rule (h-set name value) (push name value))
(define-syntax-rule (h-undo name)
	(begin
	(pop name)
	(when ( stack-empty? name) (error "no more values" 'name))
	(stack-top name)))
						
(define-syntax-rule (h-values name) (stack->list name))
;; usage
(make-h-var x)→ x

(h-set x 42) → 42
(h-set x 666)→ 666
(h-set x 'elvis)→ elvis
(h-values x) → (42 666 elvis) ;; historized values

(h-get x) → elvis
(h-undo x)→ 666
(h-undo x) → 42
(h-undo x) → ❌ error: no more values x
