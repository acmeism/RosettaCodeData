#lang racket
(require math)

(define (cholesky A)
  (define mref matrix-ref)
  (define n (matrix-num-rows A))
  (define L (for/vector ([_ n]) (for/vector ([_ n]) 0)))
  (define (set L i j x) (vector-set! (vector-ref L i) j x))
  (define (ref L i j) (vector-ref (vector-ref L i) j))
  (for* ([i n] [k n])
    (set L i k
         (cond
           [(= i k)
            (sqrt (- (mref A i i) (for/sum ([j k]) (sqr (ref L k j)))))]
           [(> i k)
            (/ (- (mref A i k) (for/sum ([j k]) (* (ref L i j) (ref L k j))))
               (ref L k k))]
           [else 0])))
  L)

(cholesky (matrix [[25 15 -5]
                   [15 18  0]
                   [-5  0 11]]))

(cholesky (matrix [[18 22  54 42]
                   [22 70  86 62]
                   [54 86 174 134]
                   [42 62 134 106]]))
