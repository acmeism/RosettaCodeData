#lang racket
(define (non-continuous-subseqs l)
  (let loop ([l l] [x 0])
    (if (null? l) (if (>= x 3) '(()) '())
        (append (for/list ([l2 (loop (cdr l) (if (even? x) (add1 x) x))])
                  (cons (car l) l2))
                (loop (cdr l) (if (odd? x) (add1 x) x))))))
(non-continuous-subseqs '(1 2 3 4))
;; => '((1 2 4) (1 3 4) (1 3) (1 4) (2 4))
