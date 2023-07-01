(lib 'matrix)

;; in : initialized dist and next matrices
;; out : dist and next matrices
;; O(n^3)

(define (floyd-with-path n dist next (d 0))
    (for* ((k n) (i n) (j n))
     #:break (< (array-ref dist j j) 0) => 'negative-cycle
    (set! d (+ (array-ref dist i k) (array-ref dist k j)))
     (when (< d (array-ref dist i j))
         (array-set! dist i j d)
         (array-set! next i j (array-ref next i k)))))

;; utilities

;; init random edges costs, matrix 66% filled
(define (init-edges n dist next)
   (for* ((i n) (j n))
    (array-set! dist i i 0)
    (array-set! next i j null)
    #:continue (= j i)
    (array-set! dist i j Infinity)
     #:continue (< (random) 0.3)
     (array-set! dist i j (1+ (random 100)))
    (array-set! next i j j)))

;; show path from u to v
(define (path u v)
    (cond
     ((= u v) (list u))
     ((null? (array-ref next u v)) null)
     (else (cons u (path (array-ref next u v) v)))))

(define( mdist u v) ;; show computed distance
      (array-ref dist u v))

(define (task)
     (init-edges n dist next)
     (array-print dist) ;; show init distances
     (floyd-with-path n dist next))
