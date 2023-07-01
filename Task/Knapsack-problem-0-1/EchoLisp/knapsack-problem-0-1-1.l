(require 'struct)
(require 'hash)
(require 'sql)

(define H (make-hash))
(define T (make-table (struct goodies (name poids valeur ))))
(define-syntax-rule (name i) (table-xref T i 0))
(define-syntax-rule (poids i) (table-xref T i 1))
(define-syntax-rule (valeur i) (table-xref T i 2))

;;  make an unique hash-key from (i rest)
(define (t-idx i r)  (string-append i "|" r))
;; retrieve best score for item i, remaining r availbble weight
(define (t-get i r)  (or (hash-ref H (t-idx i r)) 0))

;; compute best score (i), assuming best (i-1 rest) is known
(define (score i restant)
	(if (< i 0) 0
	(hash-ref! H (t-idx i restant)
		(if ( >= restant (poids i))
			(max
				(score (1- i) restant)
			    (+ (score (1- i) (- restant (poids i))) (valeur i)))
		    (score (1- i) restant)))))

;; compute best scores, starting from last item
(define (task W)
        (define restant W)
        (define N (1- (table-count T)))
		(writeln 'total-value (score N W))
		(for/list  ((i (in-range N -1 -1)))
			#:continue (= (t-get i restant) (t-get (1- i) restant))
			(set! restant (- restant (poids i)))
			(name i)))
