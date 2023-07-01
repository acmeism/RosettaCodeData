(lib 'hash)
(lib 'list) ;; permutations

(define H (make-hash))

;; G R A P H
;; generate 'normalized' starter vectors  D[i] = number of digits 'i' (0 <=i < 10)
;; reduce graph size : 9009, 9900 ..  will be generated once : vector #(2 0 0 0 0 0 0 0 0 2)

(define (generate D dstart ndigits (sd 0))
(when (> ndigits 0)
	(set! sd (vector-ref D dstart)) ;; save before recurse
	(for ((i (in-range 0 (1+ ndigits))))
		#:continue (and ( = i 0) (> dstart 0))
		(vector-set! D dstart i)
		(sequence D) ;; sequence length from D
		(for ((j (in-range (1+ dstart) 10)))
		(generate D j  (- ndigits i))))
	(vector-set! D dstart sd))) ;; restore
	

;; compute follower of D (at most 99 same digits)
(define (dnext D (dd 0))
	(define N (make-vector 10))
	(for ((d D) (i 10))
		#:continue (zero? d)
		(vector-set! N i (1+ (vector-ref N i)))
		(if (< d 10)
		(vector-set! N d (1+ (vector-ref N d))) ;; d < 9
		(begin
		(set! dd (modulo d 10))
		(vector-set! N dd (1+ (vector-ref N dd)))
		(set! dd (quotient d 10))
		(vector-set! N dd (1+ (vector-ref N dd))))))
		N)
		
		
;; update all nodes in same sequence
;; seq-length (next D) = 1 - seq-length(D)
(define (sequence D)
(define (dists D d)
	(unless (hash-ref H D)
		  (hash-set H  D d)
		  (dists (dnext D ) (1- d))))
		
		(unless  (hash-ref H D)
				 (dists D (sequence-length D))))		
		
;; sequence length from D
;; stops on loop found (node N)
(define (sequence-length D )
(define (looper N looplg depth) ;; looper 2 : a b a
	(when ( > depth 0)
			(hash-set H N looplg)
			(looper (dnext N)  looplg (1- depth))))
			
		(define followers (make-hash))
		(define N (dnext D))
		(define seqlg 0)
		(define looplg 0)
		
		(hash-set followers D 0)
		
	(set! seqlg
		(for ((lg (in-naturals 1 )))
			 #:break (hash-ref H N) =>  (+ lg (hash-ref H N)) ;; already known
			 #:break (hash-ref followers N) => lg ;; loop found
			 (hash-set followers N lg)
			 (set! N (dnext N))))
			
;; update nodes in loop : same seq-length
		(when (hash-ref followers N) ;; loop found
			(set! looplg  ( - seqlg  (hash-ref followers N)))
			(looper N looplg looplg))
		
		seqlg )
		
;; O U T P U T
;; backwards from D - normalized vector - to numbers (as strings)
(define (starters D)
(define (not-leading-zero list) (!zero? (first list)))
	(map list->string
	(filter not-leading-zero (make-set (permutations (for/fold (acc null) ((d D) (i 10))
		#:continue (zero? d)
		(append acc   (for/list ((j d)) i))))))))
	
		
;; printing one node
(define (D-print D)
	 (set! D (reverse (vector->list D)))
	 (for/string ( (d D) (i (in-range 9 -1 -1)))
		#:continue (zero? d)
		(string-append d i)))
			
;; print graph contents
(define (print-sequence D)
		(writeln 1 (starters D))
		(writeln 2 (D-print D ))
		(for ((i (in-range 1 (hash-ref H D))))
			(writeln (+ i 2)  (D-print (setv! D (dnext D))))))
	

;; TA S K
(define (task (n 6)  (verbose #t))
	(generate (make-vector 10) 0 n)
	(define seqmax (apply max (hash-values H)))
	(when verbose (for ((kv H))
		#:continue (!= (rest kv ) seqmax)
		(print-sequence (first kv))))

	(writeln (expt 10 n) '--> 'max-sequence= (1+ seqmax)  'nodes= (length (hash-values H))))
	
