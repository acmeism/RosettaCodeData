(require 'plot)
(define *knight-moves*
	'((2 . 1)(2 . -1 ) (1 . -2) (-1 . -2  )(-2 . -1) (-2 . 1) (-1 . 2) (1 . 2)))
(define *hit-squares* null)
(define *legal-moves* null)
(define *tries* 0)

(define (square x y n ) (+ y (* x n)))
(define (dim n) (1- (* n n))) ; n^2 - 1

;; check legal knight move from sq
;; return null or (list destination-square)

(define (legal-disp n sq k-move)
 (let ((x (+ (quotient sq n) (first k-move)))
 	   (y (+  (modulo sq n)  (rest k-move))))
 	   (if (and (>= x 0) (< x n) (>= y 0) (< y n))
 	       (list (square x y n))  null)))
 	
 ;; list of legal destination squares from sq
 (define (legal-moves  sq  k-moves n )
           (if (null? k-moves) null
           (append (legal-moves sq (rest k-moves) n) (legal-disp n sq (first k-moves)))))

;; square freedom = number of destination squares not already reached
(define (freedom sq)
		(for/sum ((dest (vector-ref *legal-moves* sq)))
				(if (vector-ref *hit-squares* dest) 0 1)))
				
;; The chess adage" A knight on the rim is dim" is false here :
;; choose to move to square with smallest freedom : Warnsdorf's rule
(define (square-sort a b)
	(< (freedom a) (freedom b)))
				
;; knight tour engine
(define (play sq step starter last-one wants-open)
(set! *tries* (1+ *tries*))
		(vector-set! *hit-squares* sq step) ;; flag used square
		(if (= step last-one) (throw 'HIT last-one)) ;; stop on first path found

		(when (or wants-open ;; cut search iff closed path
		(and  (< step last-one) (> (freedom starter) 0))) ;; this ensures a closed path
		
		(for ((target (list-sort square-sort (vector-ref *legal-moves* sq))))
			 (unless (vector-ref *hit-squares* target)
			         (play target (1+ step)  starter last-one wants-open))))
		(vector-set! *hit-squares* sq #f)) ;; unflag used square
		
(define (show-steps n wants-open)
	(string-delimiter "")
	(if wants-open
		(printf "♘-tour: %d tries."  *tries*)
		(printf "♞-closed-tour: %d tries."  *tries*))
	(for ((x n))
		(writeln)
		(for((y n))
        	(write (string-pad-right (vector-ref *hit-squares*  (square x y n)) 4)))))


(define (k-tour (n  8) (starter 0) (wants-open #t))
(set! *hit-squares* (make-vector (* n n) #f))
;; build vector of legal moves for squares 0..n^2-1
(set! *legal-moves*
		(build-vector (* n n) (lambda(sq) (legal-moves sq *knight-moves* n))))
(set! *tries* 0) ; counter
	(try
		(play starter 0 starter (dim n) wants-open)
		(catch (hit mess) (show-steps n wants-open))))
