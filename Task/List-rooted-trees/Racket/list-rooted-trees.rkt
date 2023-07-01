#lang racket
(require racket/splicing data/order)

(define (filtered-cartesian-product #:f (fltr (λ (cand left) #t)) l . more-ls)
  (let inr ((lls (cons l more-ls)) (left null))
    (match lls
      [(list) '(())]
      [(cons lla lld)
       (for*/list ((a (in-list (filter (curryr fltr left) lla)))
                   (d (in-list (inr lld (cons a left)))))
         (cons a d))])))

;; The "order" of an LRT
(define LRT-order (match-lambda [(list (app LRT-order o) ...) (apply + 1 o)]))

;; Some order for List Rooted Trees
(define LRT<=
  (match-lambda**
   [(_ (list)) #t]
   [((and bar (app LRT-order baro)) (cons (and badr (app LRT-order badro)) bddr))
    (and (or (< baro badro) (not (eq? '> (datum-order bar badr)))) (LRT<= badr bddr))]))

(splicing-letrec ((t# (make-hash '((1 . (())))))
                  (p# (make-hash '((0 . (()))))))
  ;; positive-integer -> (listof (listof positive-integer))
  (define (partitions N)
    (hash-ref! p# N
               (λ () (for*/list ((m (in-range 1 (add1 N)))
                                 (p (partitions (- N m)))
                                 #:when (or (null? p) (>= m (car p))))
                       (cons m p)))))

  ;; positive-integer -> (listof trees)
  (define (LRTs N)
    (hash-ref! t# N
               (λ ()
                 ;; sub1 because we will use the N'th bag to wrap the lot!
                 (define ps (partitions (sub1 N)))
                 (append*
                  (for/list ((p ps))
                    (apply filtered-cartesian-product (map LRTs p) #:f LRT<=)))))))

(module+ main
  (for-each displayln (LRTs 5))
  (equal? (map (compose length LRTs) (range 1 (add1 13)))
          '(1 1 2 4 9 20 48 115 286 719 1842 4766 12486))) ;; https://oeis.org/A000081
