#lang racket

(define a (vector 1.00000000E0 -2.77555756E-16 3.33333333E-01 -1.85037171E-17))
(define b (vector 0.16666667E0 0.50000000E0 0.50000000E0 0.16666667E0))
(define s (vector -0.917843918645 0.141984778794  1.20536903482   0.190286794412 -0.662370894973
                  -1.00700480494 -0.404707073677  0.800482325044  0.743500089861  1.01090520172
                  0.741527555207 0.277841675195  0.400833448236 -0.2085993586   -0.172842103641
                  -0.134316096293 0.0259303398477 0.490105989562  0.549391221511  0.9047198589))

(define (filter-signal-direct-form-ii-transposed coeff1 coeff2 signal)
  (define signal-size (vector-length signal))
  (define filtered-signal (make-vector signal-size 0))
  (for ((i signal-size))
    (vector-set! filtered-signal
                 i
                 (/ (for/fold ((s (for/fold ((s 0)) ((j (vector-length coeff2)) #:when (>= i j))
                                    (+ s (* (vector-ref coeff2 j) (vector-ref signal (- i j)))))))
                              ((j (vector-length coeff1)) #:when (>= i j))
                      (- s (* (vector-ref coeff1 j) (vector-ref filtered-signal (- i j)))))
                    (vector-ref coeff1 0))))
  filtered-signal)

(filter-signal-direct-form-ii-transposed a b s)
