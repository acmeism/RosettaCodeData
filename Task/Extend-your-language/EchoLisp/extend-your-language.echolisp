(define-syntax-rule
	(if2 cond1 cond2 both cond1-only cond2-only none) ;; new syntax
;; will expand to :
	(if cond1
		(if cond2 both cond1-only)
		(if cond2 cond2-only none)))
   → #syntax:if2

(define (num-test n)
    (if2 (positive? n) (exact? n)
	  "positive and exact"
	  "positive and inexact"
	  "negative and exact"
	  "negative and inexact"))
	
(num-test 3/4)
   → "positive and exact"
(num-test -666)
   → "negative and exact"
(num-test -666.42)
   → "negative and inexact"
(num-test PI)
   → "positive and inexact"
