#lang typed/racket
(require math/array)

;; in : initialized dist and next matrices
;; out : dist and next matrices
;; O(n^3)
(define-type Next-T (Option Index))
(define-type Dist-T Real)
(define-type Dists (Array Dist-T))
(define-type Nexts (Array Next-T))
(define-type Settable-Dists (Settable-Array Dist-T))
(define-type Settable-Nexts (Settable-Array Next-T))

(: floyd-with-path (-> Index Dists Nexts (Values Dists Nexts)))
(: init-edges (-> Index (Values Settable-Dists Settable-Nexts)))

(define (floyd-with-path n dist-in next-in)
  (define dist : Settable-Dists (array->mutable-array dist-in))
  (define next : Settable-Nexts (array->mutable-array next-in))
  (for* ((k n) (i n) (j n))
    (when (negative? (array-ref dist (vector j j)))
      (raise 'negative-cycle))
    (define i.k (vector i k))
    (define i.j (vector i j))
    (define d (+ (array-ref dist i.k) (array-ref dist (vector k j))))
    (when (< d (array-ref dist i.j))
      (array-set! dist i.j d)
      (array-set! next i.j (array-ref next i.k))))
  (values dist next))

;; utilities

;; init random edges costs, matrix 66% filled
(define (init-edges n)
  (define dist : Settable-Dists (array->mutable-array (make-array (vector n n) 0)))
  (define next : Settable-Nexts (array->mutable-array (make-array (vector n n) #f)))
  (for* ((i n) (j n) #:unless (= i j))
    (define i.j (vector i j))
    (array-set! dist i.j +Inf.0)
    (unless (< (random) 0.3)
      (array-set! dist i.j (add1 (random 100)))
      (array-set! next i.j j)))
  (values dist next))

;; show path from u to v
(: path (-> Nexts Index Index (Listof Index)))
(define (path next u v)
  (let loop : (Listof Index) ((u : Index u) (rv : (Listof Index) null))
    (if (= u v)
        (reverse (cons u rv))
        (let ((nxt (array-ref next (vector u v))))
          (if nxt (loop nxt (cons u rv)) null)))))

;; show computed distance
(: mdist (-> Dists Index Index Dist-T))
(define (mdist dist u v)
  (array-ref dist (vector u v)))

(module+ main
  (define n 8)
  (define-values (dist next) (init-edges n))
  (define-values (dist+ next+) (floyd-with-path n dist next))
  (displayln "original dist")
  dist
  (displayln "new dist and next")
  dist+
  next+
  ;; note, these path and dist calls are not as carefully crafted as
  ;; the echolisp ones (in fact they're verbatim copied)
  (displayln "paths and distances")
  (path  next+ 1 3)
  (mdist dist+ 1 0)
  (mdist dist+ 0 3)
  (mdist dist+ 1 3)
  (path next+ 7 6)
  (path next+ 6 7))
