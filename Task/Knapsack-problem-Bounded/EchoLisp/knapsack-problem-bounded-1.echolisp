(lib 'struct)
(lib 'sql)
(lib 'hash)

(define H (make-hash))
(define T (make-table (struct goodies (name poids valeur qty))))
(define IDX (make-vector 0))


;; convert to 0/1 PB
;; transorm vector [1 2 3 4 (n-max 3) 5 (n-max 2) 6 .. ]
;; into vector of repeated indices : [1 2 3 4 4 4 5 5 6 ... ]

(define (make-01 T)
	 (for ((record T) (i (in-naturals)))
		 (for ((j (in-range 0 (goodies-qty record))))
			 (vector-push IDX i)))
	 IDX)
	
(define-syntax-rule (name i) (table-xref T (vector-ref IDX i) 0))
(define-syntax-rule (poids i) (table-xref T (vector-ref IDX i) 1))
(define-syntax-rule (valeur i) (table-xref T (vector-ref IDX i) 2))

;;
;; code identical to 0/1 problem	
;;

;;  make an unique hash-key from (i rest)
(define (t-idx i r)  (string-append i "|" r))
;; retrieve best core for item i, remaining r availbble weight
(define (t-get i r)  (or (hash-ref H (t-idx i r)) 0))

;; compute best score (i), assuming best (i-1 rest) is known
(define (score i restant)
	 (if (< i 0) 0
	 (hash-ref! H (t-idx i restant)
		 (if ( >= restant (poids i))
			 (max
			 (score (1- i) restant)
			 (+ (score (1- i) (- restant (poids i))) (valeur i)))
		    (score (1- i) restant)) ;; else not enough
	)))
	
;; compute best scores, starting from last item
(define (task W)
        (define restant W)
        (make-01 T)
        (define N (1- (vector-length IDX)))
		 (writeln 'total-value (score N W))
		 (group
		 (for/list  ((i (in-range N -1 -1)))
		 #:continue (= (t-get i restant) (t-get (1- i) restant))
		(set! restant (- restant (poids i)))
		(name i))))
