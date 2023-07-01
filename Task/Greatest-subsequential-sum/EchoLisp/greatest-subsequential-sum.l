(lib 'struct)
(struct result (score starter))

;; the score of  i in sequence ( .. i j ...)  is max (i , i + score (j))
;; to compute score of (a b .. x y z) :
;; start with score(z) and compute scores of y , z , ..c, b , a.
;; this is O(n)

;; return value of sub-sequence
(define (max-max L into: result)
(define value
	(if
	(empty? L) -Infinity
	(max (first L)  (+ (first L) (max-max (cdr L) result )))))
	
    (when (> value (result-score result))
		(set-result-score! result value) ;; remember best score
		(set-result-starter! result L))  ;; and its location
	value)

;; return (best-score (best sequence))
(define (max-seq L)
	(define best (result -Infinity null))
	(max-max L into: best)
	(define score (result-score best))
	
	(list score
	(for/list (( n (result-starter best)))
			   #:break (zero? score)
			   (set! score (- score n))
			   n)))
	
(define L '(-1 -2 3 5 6 -2 -1 4 -4 2 -1))
(max-seq L)
    → (15 (3 5 6 -2 -1 4))
