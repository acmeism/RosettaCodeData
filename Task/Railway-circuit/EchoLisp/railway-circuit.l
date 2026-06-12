;; R is turn counter in right direction
;; The nb of right turns in direction i
;; must be = to nb of right turns in direction i+6 (opposite)
(define (legal? R)
	(for ((i 6))
		#:break (!= (vector-ref R i) (vector-ref R (+ i 6))) => #f
		#t))
		

;; equal circuits by rotation ?
(define (circuit-eq? Ca Cb)
	(for [(i (vector-length Cb))]
		#:break (eqv? Ca (vector-rotate! Cb 1)) => #t
		#f))
		
;; check a result vector RV  of circuits
;; Remove equivalent circuits

(define (check-circuits RV)
	(define n (vector-length RV))
	(for ((i (1- n)))
		#:continue (null? (vector-ref RV i))
	(for ((j (in-range (1+ i) n )))
		#:continue (null? (vector-ref RV j))
		(when (circuit-eq? (vector-ref RV i) (vector-ref RV j))
			  (vector-set! RV j null)))))
		
	
;; global
;; *circuits* = result set = a vector
(define-values (*count* *calls*  *circuits*) (values 0 0 null))

;; generation of circuit C[i] i = 0 .... maxn including straight (may be 0) tracks
(define (circuits C Rct R D n maxn  straight )
(define _Rct Rct) ;; save area
(define _Rn (vector-ref R Rct))
(++ *calls* )

	(cond
    [(> *calls* 4_000_000) #f] ;; enough for maxn=24

    ;; hit !! legal solution
    [(and (= n maxn) ( zero? Rct ) (legal? R) (legal? D))
		(++ *count*)
		(vector-push *circuits* (vector-dup C))];; save solution
		
     ;; stop
     [( = n maxn) #f]
	
     ;; important cutter - not enough right turns
     [(and (!zero? Rct) (< (+ Rct maxn ) (+ n straight 11))) #f]
	
     [else
		;; play right
			(vector+= R Rct 1) ; R[Rct] += 1
			(set! Rct (modulo (1+ Rct) 12))
			(vector-set! C n 1)
			(circuits C Rct R  D (1+ n) maxn straight)
			
		;;	unplay it - restore values
			(set! Rct _Rct)
			(vector-set! R Rct _Rn)
			(vector-set! C n '-)
			
		;; play left
			(set! Rct (modulo (1- Rct) 12))
			(vector-set! C n -1)
			(circuits C Rct R D (1+ n) maxn straight)
			
		;;	unplay
			(set! Rct _Rct)
			(vector-set! R Rct _Rn)
			(vector-set! C n '-)
			
		;; play straight line
			(when (!zero? straight)
			(vector-set! C n 0)
			(vector+= D Rct 1)
			(circuits C Rct R D (1+ n) maxn (1- straight))
			
		;;	unplay
			(vector+= D Rct -1)
			(vector-set! C n '-)) ]))
		
;; generate maxn tracks  [ +  straight])
;; i ( 0 .. 11) * 30° are the possible directions
(define (gen (maxn 20) (straight 0))
	(define R (make-vector 12)) ;; count number of right turns in direction i
	(define D (make-vector 12)) ;; count number of straight tracks in direction i
	(define C (make-vector (+ maxn straight) '-))
	(set!-values (*count* *calls*  *circuits*) (values 0  0 (make-vector 0)))
	(vector-set! R 0 1) ;; play starter (always right)
	(vector-set! C 0 1)
	(circuits C 1 R D 1 (+ maxn straight) straight)
	(writeln 'gen-counters (cons *calls* *count*))
	
	(check-circuits *circuits*)
	(set! *circuits* (for/vector ((c *circuits*)) #:continue (null? c) c))
	(if (zero? straight)
		(printf "Number of circuits C%d : %d" maxn (vector-length *circuits*))
		(printf "Number of circuits C%d,%d : %d" maxn  straight (vector-length *circuits*)))
	(when (< (vector-length *circuits*) 20) (for-each writeln *circuits*)))
