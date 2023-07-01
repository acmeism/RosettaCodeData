#lang racket/base

(define r-cache (make-hash '((1 . 1) (2 . 3) (3 . 7))))
(define s-cache (make-hash '((1 . 2) (2 . 4) (3 . 5) (4 . 6))))

(define (extend-r-s!)
  (define r-count (hash-count r-cache))
  (define s-count (hash-count s-cache))
  (define last-r (ffr r-count))
  (define new-r (+ (ffr r-count) (ffs r-count)))
  (hash-set! r-cache (add1 r-count) new-r)
  (define offset (- s-count last-r))
  (for ([val (in-range (add1 last-r) new-r)])
    (hash-set! s-cache (+ val offset) val)))
