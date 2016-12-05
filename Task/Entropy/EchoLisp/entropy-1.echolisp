(lib 'hash)
;; counter: hash-table[key]++
(define (count++ ht k )
(hash-set ht k (1+ (hash-ref! ht k 0))))

(define (hi count n )
	(define pi (// count n))
	(- (* pi (log2 pi))))
	
;; (H [string|list]) → entropy (bits)
(define (H info)
	(define S (if(string? info) (string->list info) info))
	(define ht (make-hash))
	(define n (length S))
	
	(for ((s S)) (count++ ht s))
	(for/sum ((s (make-set S)))  (hi (hash-ref ht s) n)))
	
