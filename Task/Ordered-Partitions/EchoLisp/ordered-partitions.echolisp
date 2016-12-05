(lib 'list) ;; (combinations L k)

;; add a combination to each partition in ps
(define (pproduct c ps) (for/list ((x ps)) (cons c x)))

;; apply to any type of set S
;; ns is list of cardinals for each partition
;;     for all combinations Ci of n objects from  S
;;           set S <- LS minus Ci , set n <- next n , and recurse

(define (_partitions S ns )
    (cond
    ([empty? (rest ns)]  (list (combinations S (first ns))))
    (else
        (for/fold (parts null)
        ([c (combinations S (first ns))])
        (append
           parts
           (pproduct c (_partitions (set-substract S c) (rest ns))))))))

;; task : S = ( 0 , 1 ... n-1) args = ns
(define (partitions . args)
    (for-each
	 writeln
        (_partitions (range 1  (1+ (apply + args))) args )))
