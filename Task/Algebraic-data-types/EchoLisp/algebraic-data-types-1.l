;; code adapted from Racket and Common Lisp
;; Illustrates matching on structures
(require 'match)
(require 'struct)


(define (N-tostring n) (format "%s %d"  (N-color n) (N-value n)))
(struct N (color left value right) #:tostring N-tostring)

(define (balance t)
  (match t
    [(N '⚫️ (N '🔴 (N '🔴 a x b) y c) z d) (N '🔴 (N '⚫️ a x b) y (N '⚫️ c z d))]
    [(N '⚫️ (N '🔴 a x (N '🔴 b y c)) z d) (N '🔴 (N '⚫️ a x b) y (N '⚫️ c z d))]
    [(N '⚫️ a x (N '🔴 (N '🔴 b y c) z d)) (N '🔴 (N '⚫️ a x b) y (N '⚫️ c z d))]
    [(N '⚫️ a x (N '🔴 b y (N '🔴 c z d))) (N '🔴 (N '⚫️ a x b) y (N '⚫️ c z d))]
    [else t]))

    (define (ins value: x  tree: t)
    (match t
      ['empty (N '🔴 'empty x 'empty)]
      [(N c l v r) (cond [(< x v) (balance (N c (ins x l) v r))]
                         [(> x v) (balance (N c l v (ins x r)))]
                         [else t])]))

	(define (insert value: x tree: s)
  		(match (ins x s) [(N _ l v r) (N '⚫️ l v r)]))
  	
