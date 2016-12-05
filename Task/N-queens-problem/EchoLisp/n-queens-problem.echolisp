;; square num is i + j*N
(define-syntax-rule (sq i j) (+ i (* j N)))

;; compute diag number for each square
(define (do-diag1 i0 j0  dnum  into: dnum1 N) ;; ++i and ++j diags
	(for [(i (in-range i0 N)) (j (in-range j0 N))]
		;;(writeln   i j 'diag1 dnum)
		(vector-set! dnum1 (sq i j) dnum)))
		
(define (do-diag2 i0 j0  dnum into: dnum2 N) ;; --i and ++j diags
	(for [(i (in-range i0 -1 -1)) (j (in-range j0 N))]
		;; (writeln i j 'diag2 dnum)
		(vector-set! dnum2 (sq i j) dnum)))
		
(define (init-diags dnum1 dnum2 N)
	(define dnum 0)
		(for ((j N)) (do-diag1 0 j dnum dnum1 N) (++ dnum))
		(for ((i (in-range 1 N)))
                     (do-diag1 i 0 dnum dnum1  N) (++ dnum))
	(set! dnum 0)
		(for ((j N)) (do-diag2 (1- N) j dnum dnum2 N) (++ dnum))
		(for ((i (1- N))) (do-diag2 i 0 dnum dnum2 N) (++ dnum)))
;; end boring diags part
		
(define (q-search i  N col diag1 diag2 dnum1 dnum2    &hits (ns))
(cond
[(= i N)  (set-box! &hits (1+ (unbox &hits))) ] ;;  (writeln  'HIT col)
	[else
	
		(for ((j N))
		(set! ns (sq i j))
		#:continue (or [col j] [diag1 [dnum1 ns]] [diag2 [dnum2 ns]])
		     (vector-set! col j i) ;; move
		     (vector-set! diag1 [dnum1 ns] #t) ;; flag busy diagonal
			(vector-set! diag2 [dnum2 ns] #t)
			(q-search (1+ i) N col diag1 diag2 dnum1 dnum2 &hits)
			(vector-set! col j #f) ;; unmove
			(vector-set! diag1 [dnum1 ns] #f)
			(vector-set! diag2 [dnum2 ns] #f))
			]))
			
(define (q-count (N 8))
	(define dnum1 (make-vector (* N N)))
	(define dnum2 (make-vector (* N N )))
	(init-diags dnum1 dnum2 N)
	
	(define diag1 (make-vector (* 2 N) #f)) ; busy diag's
	(define diag2 (make-vector (* 2 N) #f))
	(define col (make-vector N  #f))
	(define &hits (box 0))
	
	
	(q-search 0 N col diag1 diag2 dnum1 dnum2  &hits)
	(unbox &hits))
	
(define (task up-to-n)
	(for ((i up-to-n)) (writeln i ' ♕ (q-count i) 'solutions)))
