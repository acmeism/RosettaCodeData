#lang racket
(define memo (make-hash))
(hash-set! memo 1 '((1) 1))

(define (hailstone n)
  (hash-ref memo n
   (λ ()
     (define h (hailstone (if (even? n) (/ n 2) (+ (* 3 n) 1))))
     (hash-set! memo n (list (cons n (first h)) (+ (second h) 1)))
     (hash-ref memo n))))

(define h27 (first (hailstone 27)))

(printf "first 4 elements of h(27): ~v\n" (take h27 4))
(printf "last  4 elements of h(27): ~v\n" (take-right h27 4))

(printf "x < 10000 such that h(x) gives the longest sequence: ")
(for/fold ([m 0]) ([n (in-range 1 100000)])
  (max m (second (hailstone n))))
