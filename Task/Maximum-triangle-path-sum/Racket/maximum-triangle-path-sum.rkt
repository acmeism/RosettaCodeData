#lang racket
(require math/number-theory)

(define (trinv n) ; OEIS A002024
  (exact-floor (/ (+ 1 (sqrt (* 1 (* 8 n)))) 2)))

(define (triangle-neighbour-bl n)
  (define row (trinv n))
  (+ n (- (triangle-number row) (triangle-number (- row 1)))))

(define (maximum-triangle-path-sum T)
  (define n-rows (trinv (vector-length T)))
  (define memo# (make-hash))
  (define (inner i)
    (hash-ref!
     memo# i
     (λ ()
       (+ (vector-ref T (sub1 i)) ; index is 1-based (so vector-refs need -1'ing)
          (cond [(= (trinv i) n-rows) 0]
                [else
                 (define bl (triangle-neighbour-bl i))
                 (max (inner bl) (inner (add1 bl)))])))))
  (inner 1))

(module+ main
  (maximum-triangle-path-sum
   #(55
     94 48
     95 30 96
     77 71 26 67
     97 13 76 38 45
     07 36 79 16 37 68
     48 07 09 18 70 26 06
     18 72 79 46 59 79 29 90
     20 76 87 11 32 07 07 49 18
     27 83 58 35 71 11 25 57 29 85
     14 64 36 96 27 11 58 56 92 18 55
     02 90 03 60 48 49 41 46 33 36 47 23
     92 50 48 02 36 59 42 79 72 20 82 77 42
     56 78 38 80 39 75 02 71 66 66 01 03 55 72
     44 25 67 84 71 67 11 61 40 57 58 89 40 56 36
     85 32 25 85 57 48 84 35 47 62 17 01 01 99 89 52
     06 71 28 75 94 48 37 10 23 51 06 48 53 18 74 98 15
     27 02 92 23 08 71 76 84 15 52 92 63 81 10 44 10 69 93)))

(module+ test
  (require rackunit)
  (check-equal? (for/list ((n (in-range 1 (add1 10)))) (trinv n)) '(1 2 2 3 3 3 4 4 4 4))
  ;    1
  ;   2 3
  ;  4 5 6
  ; 7 8 9 10
  (check-eq? (triangle-neighbour-bl 1) 2)
  (check-eq? (triangle-neighbour-bl 3) 5)
  (check-eq? (triangle-neighbour-bl 5) 8)
  (define test-triangle
    #(55   94 48   95 30 96   77 71 26 67))
  (check-equal? (maximum-triangle-path-sum test-triangle) 321)
  )
