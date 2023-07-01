(lib 'compile) ;; for (compile)
(lib 'bigint)  ;; integer results > 32 bits
(lib 'hash)    ;; hash table

;; h-table
(define Hcoins (make-hash))

;; the function to memoize
(define (sumways cents coins)
	(+ (ways cents (cdr coins)) (ways (- cents (car coins)) coins)))
	
;; accelerator : ways (cents, coins) = ways ((cents  - cents % 5) , coins)
(define (ways cents coins)
  (cond ((null? coins) 0)
        ((negative? cents) 0)
        ((zero? cents) 1)
        ((eq? coins c-1) 1) ;; if coins = (1) --> 1
        (else (hash-ref! Hcoins (list (- cents (modulo cents 5)) coins) sumways))))

(compile 'ways) ;; speed-up things
