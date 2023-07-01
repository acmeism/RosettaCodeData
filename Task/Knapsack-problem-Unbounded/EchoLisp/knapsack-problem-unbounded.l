(require 'struct)
(require 'hash)
(require 'sql)

(define H null) ;; cache
(define T (make-table (struct goodies (name valeur poids volume ))))
(define-syntax-rule (name i) (table-xref T i 0))
(define-syntax-rule (valeur i) (table-xref T i 1))
(define-syntax-rule (poids i) (table-xref T i 2))
(define-syntax-rule (volume i) (table-xref T i 3))


(define goodies
  '(("🍁-panacea"  3000 300 25)
   ("🌵-ichor"    1800 200 15)
   ("⭐️-gold"     2500 2000 2)))

(list->table goodies T)

;; i = item index, p= remaining weight, v = remaining volume

;;  make an unique hash-key from (i p v)
(define (t-key i p v)  (string-append i "|" p "|" v))

;; retrieve best core for item i
;; returns ( score . quantity)

(define (t-get i p v)
   (if ( < i 0) (cons 0 0)
      (hash-ref H (t-key i p v )))) ;; may be #f

;; compute best quantity.score (i), assuming best (i-1 p v) is known
(define (score-qty i p v (q) (score)(smax)(qmax))
	 (or
	 (t-get i p v) ;; already known
	 (begin
 		(set! q (min (quotient p (poids i)) (quotient v (volume i)))) ;; max possible q
 		(set! smax -Infinity)
		    ( for ((k (1+ q))) ;; try all legal quantities
		      (set! score (+
		         (first (score-qty (1- i) (- p (* k (poids i))) (- v (* k (volume i)))))
		         (* k (valeur i))))
		     #:continue (< score smax)
		      (set! smax score)
		      (set! qmax k))
		 (hash-set H (t-key i p v) (cons smax qmax)))))
		
		
;; compute best scores, starting from last item
(define (task P V)
        (define N (1- (table-count T)))
        (define qty 0)
        (set! H (make-hash))
	(writeln 'total-value (first (score-qty N P V)))
		
	(for/list  ((i (in-range N -1 -1)))
			(set! qty (rest (t-get i P V)))
			#:continue (= qty 0)
			(begin0
			(cons (name i) (t-get i P V))
			(set! P (- P (* (poids i) qty)))
			(set! V (- V (* (volume i) qty))))))

;; output
(task 25000 250)
total-value     54500
    → (("⭐️-gold" 54500 . 11) ("🌵-ichor" 27000 . 15))

(length (hash-keys H)) ;; # entries in cache
    → 218
