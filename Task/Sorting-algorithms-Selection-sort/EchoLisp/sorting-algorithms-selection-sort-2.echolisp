;; sort an array in place
(define (sel-sort a  (amin) (imin))
	(define ilast (1- (vector-length a)))
	(for [(i ilast)]
		(set! amin [a (setv! imin i)]) ;; imin := i , amin := a[imin]
		(for [(j (in-range (1+ i) (1+ ilast)))]
			(when (< [a j] amin) (set! amin [a (setv! imin j)])))
		(vector-swap! a i imin))
		a )
	
(define a #(9 8 2 6 3 5 4))
(sel-sort a)
    → #( 2 3 4 5 6 8 9)		
