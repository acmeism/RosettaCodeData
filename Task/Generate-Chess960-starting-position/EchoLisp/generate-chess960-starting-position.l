(define-values (K Q R B N) (iota 5))
(define *pos* (list R N B Q K B N R)) ;; standard starter

;; check opposite color bishops, and King between rooks
(define (legal-pos p)
    (and
            (> (list-index K p) (list-index R p))
            (> (list-index K (reverse p)) (list-index R (reverse p)))
            (even? (+ (list-index B p) (list-index B (reverse p))))))

;; random shuffle current position until a legal one is found
(define (c960)
	(set! *pos* (shuffle *pos*))
	(if (legal-pos *pos*)
		(map unicode-piece *pos*)  (c960)))
