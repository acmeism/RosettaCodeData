#lang racket

; A tree consists of a point, a left and a right subtree.
(struct tree (p l r) #:transparent)
; If the node is in depth d, then the points in l has
; the (d mod k)'th coordinate less than the same coordinate in p.

(define (kdtree d k ps)
  (cond [(empty? ps) #f] ; #f represents an empty subtree
        [else (define-values (p l r) (split-points ps (modulo d k)))
              (tree p (kdtree (+ d 1) k l) (kdtree (+ d 1) k r))]))

(define (split-points ps d)
  (define (ref p) (vector-ref p d))
  (define sorted-ps (sort ps < #:key ref))
  (define mid (quotient (+ (length ps)) 2))
  (define median (ref (list-ref sorted-ps mid)))
  (define-values (l r) (partition(λ(x)(< (ref x) median))sorted-ps))
  (values (first r) l (rest r)))

; The bounding box of a subtree:
(struct bb (mins maxs) #:transparent)

(define (infinite-bb k)
  (bb (make-vector k -inf.0) (make-vector k +inf.0)))

(define/match (copy-bb h)
  [((bb mins maxs))
   (bb (vector-copy mins) (vector-copy maxs))])

(define (dist v w) (for/sum ([x v] [y w]) (sqr (- x y))))
(define (intersects? g r hr) (<= (dist (closest-in-hr g hr) g) r))
(define (closest-in-hr g hr)
  (for/vector ([gi g] [mini (bb-mins hr)] [maxi (bb-maxs hr)])
    (cond [(<=     gi mini) mini]
          [(< mini gi maxi) gi]
          [else             maxi])))

(define (split-bb hr d x)
  (define left  (copy-bb hr))
  (define right (copy-bb hr))
  (vector-set! (bb-maxs left) d x)
  (vector-set! (bb-mins right) d x)
  (values left right))

(define visits 0) ; for statistics only
(define (visit) (set! visits (+ visits 1)))
(define (reset-visits) (set! visits 0))
(define (regret-visit) (set! visits (- visits 1)))

(define (nearest-neighbor g t k)
  (define (nearer? p q) (< (dist p g) (dist q g)))
  (define (nearest p q) (if (nearer? p q) p q))
  (define (nn d t bb) (visit)
    (define (ref p) (vector-ref p (modulo d k)))
    (match t
      [#f (regret-visit) #(+inf.0 +inf.0 +inf.0)]
      [(tree p l r)
       (define-values (lbb rbb) (split-bb bb (modulo d k) (ref p)))
       (define-values (near near-bb far far-bb)
         (if (< (ref g) (ref p))
             (values l lbb r rbb)
             (values r rbb l lbb)))
       (define n (nearest p (nn (+ d 1) near near-bb)))
       (if (intersects? g (dist n g) far-bb)
           (nearest n (nn (+ d 1) far far-bb))
           n)]))
  (nn 0 t (infinite-bb k)))
