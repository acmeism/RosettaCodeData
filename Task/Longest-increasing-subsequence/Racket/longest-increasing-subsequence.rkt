#lang racket/base
(require data/gvector)

(define (gvector-last gv)
  (gvector-ref gv (sub1 (gvector-count gv))))

(define (lis-patience-sort input-list)
  (let ([piles (gvector)])
    (for ([item (in-list input-list)])
      (insert-item! piles item))
    (reverse (gvector-last piles))))

(define (insert-item! piles item)
  (if (zero? (gvector-count piles))
      (gvector-add! piles (cons item '()))
      (cond
        [(not (<= item (car (gvector-last piles))))
         (gvector-add! piles (cons item (gvector-last piles)))]
        [(<= item (car (gvector-ref piles 0)))
         (gvector-set! piles 0 (cons item '()))]
        [else (let loop ([first 1] [last (sub1 (gvector-count piles))])
                (if (= first last)
                    (gvector-set! piles first (cons item (gvector-ref piles (sub1 first))))
                    (let ([middle (quotient (+ first last) 2)])
                      (if (<= item (car (gvector-ref piles middle)))
                          (loop first middle)
                          (loop (add1 middle) last)))))])))
