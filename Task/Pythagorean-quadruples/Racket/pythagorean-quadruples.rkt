#lang racket

(require data/bit-vector)

(define (quadruples top)
  (define top+1 (add1 top))
  (define 1..top (in-range 1 top+1))
  (define r (make-bit-vector top+1))
  (define ab (make-bit-vector (add1 (sqr (* top 2)))))
  (for* ((a 1..top) (b (in-range a top+1))) (bit-vector-set! ab (+ (sqr a) (sqr b)) #t))

  (for/fold ((s 3))
            ((c 1..top))
    (for/fold ((s1 s) (s2 (+ s 2)))
              ((d (in-range (add1 c) top+1)))
      (when (bit-vector-ref ab s1)
        (bit-vector-set! r d #t))
      (values (+ s1 s2) (+ s2 2)))
    (+ 2 s))

  (for/list ((i (in-naturals 1)) (v (in-bit-vector r 1)) #:unless v) i))

(define (report n)
  (printf "Those values of d in 1..~a that can't be represented: ~a~%" n (quadruples n)))

(report 2200)
