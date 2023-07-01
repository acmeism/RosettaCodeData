(require 'hash)
(require' amb)

;;
;; Solver
;;

(define (dwelling-puzzle context names floors H)
;; each amb calls gives a floor to a name
    (for ((name names))
		(hash-set H name (amb context floors)))
;; They live on different floors.
    (amb-require (distinct? (amb-choices context)))
    (constraints floors H) ;; may fail and backtrack
;; result returned to amb-run
    (for/list  ((name names))
    	(cons name (hash-ref H name)))
;; (amb-fail) is possible here to see all solutions
)

(define (task names)
	(amb-run dwelling-puzzle
	(amb-make-context)
	 names
	(iota (length names)) ;; list of floors : 0,1, ....
	(make-hash)) ;; hash table : "name" -> floor
	)
