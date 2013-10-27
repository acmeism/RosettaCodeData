#lang racket

(define k8 (bytes 14  4 13  1  2 15 11  8  3 10  6 12  5  9  0  7))
(define k7 (bytes 15  1  8 14  6 11  3  4  9  7  2 13 12  0  5 10))
(define k6 (bytes 10  0  9 14  6  3 15  5  1 13 12  7 11  4  2  8))
(define k5 (bytes  7 13 14  3  0  6  9 10  1  2  8  5 11 12  4 15))
(define k4 (bytes  2 12  4  1  7 10 11  6  8  5  3 15 13  0 14  9))
(define k3 (bytes 12  1 10 15  9  2  6  8  0 13  3  4 14  7  5 11))
(define k2 (bytes  4 11  2 14 15  0  8 13  3 12  9  7  5 10  6  1))
(define k1 (bytes 13  2  8  4  6 15 11  1 10  9  3 14  5  0 12  7))

(define (mk-k k2 k1)
  (list->bytes (for*/list ([i 16] [j 16]) (+ (* (bytes-ref k2 i) 16) (bytes-ref k1 j)))))

(define k87 (mk-k k8 k7))
(define k65 (mk-k k6 k5))
(define k43 (mk-k k4 k3))
(define k21 (mk-k k2 k1))

(define (f x)
  (define bs (integer->integer-bytes x 4 #f #f))
  (define x*
    (bitwise-and #xFFFFFFFF
                 (integer-bytes->integer
                  (bytes (bytes-ref k21 (bytes-ref bs 0))
                         (bytes-ref k43 (bytes-ref bs 1))
                         (bytes-ref k65 (bytes-ref bs 2))
                         (bytes-ref k87 (bytes-ref bs 3)))
                  #f #f)))
  (bitwise-ior (bitwise-and #xFFFFFFFF (arithmetic-shift x* 11))
               (arithmetic-shift x* (- 11 32))))
