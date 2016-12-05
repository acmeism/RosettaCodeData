(define (trabb-fun n)
		(+  (* 5 n n n) (sqrt(abs n))))
		
(define (check-trabb n)
	(if (number? n)
	(if (<=  (trabb-fun n) 400)
		(printf "🌱 f(%d) = %d" n (trabb-fun n))
		(printf "❌  f(%d) = %d" n (trabb-fun n)))
	(error "not a number" n)))
		
(define (trabb (numlist null))
	(while (< (length numlist) 11)
	(set! numlist (append numlist
		(or
		(read default: (shuffle (iota 11))
		      prompt: (format "Please enter %d more numbers" (- 11 (length numlist))))
		(error 'incomplete-list numlist))))) ;; users cancel
	(for-each check-trabb (reverse (take numlist 11))))
