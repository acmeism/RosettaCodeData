#lang racket
(define (pretty-fraction f)
  (if (integer? f) f
      (let* ((d (denominator f)) (n (numerator f)) (q (quotient n d)) (r (remainder n d)))
        (format "~a ~a" q (/ r d)))))

(define (test-uniformity/naive r n δ)
  (define observation (make-hash))
  (for ((_ (in-range n))) (hash-update! observation (r) add1 0))
  (define target (/ n (hash-count observation)))
  (define max-skew (* n δ 1/100))
  (define (skewed? v)
    (> (abs (- v target)) max-skew))
  (let/ec ek
    (cons
     #t
     (for/list ((k (sort (hash-keys observation) <)))
       (define v (hash-ref observation k))
       (when (skewed? v)
         (ek (cons
              #f
              (format "~a distribution of ~s potentially skewed for ~a. expected ~a got ~a"
                      'test-uniformity/naive r k (pretty-fraction target) v))))
       (cons k v)))))

(define (straight-die)
  (min 6 (add1 (random 6))))

(define (crooked-die)
  (min 6 (add1 (random 7))))

; Test whether the builtin generator is uniform:
(test-uniformity/naive (curry random 10) 1000 5)
; Test whether a straight die is uniform:
(test-uniformity/naive straight-die 1000 5)
; Test whether a biased die fails:
(test-uniformity/naive crooked-die 1000 5)
