(define dim 100)
(define-syntax-rule  (Tidx i j)  (+ i (* dim j)))

;; generates Catalan's triangle
;; T (i , j) = T(i-1,j) + T (i, j-1)

(define (T n)
	(define i (modulo n dim))
	(define j (quotient n dim))
	(cond
		((zero? i) 1) ;; left column = 1
		((= i j) (T (Tidx (1- i) j))) ;; diagonal value = left value
		(else (+ (T (Tidx (1- i) j)) (T (Tidx i (1- j)))))))
	
(remember 'T #(1))
