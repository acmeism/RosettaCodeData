#lang racket
(require math/number-theory)

(define (pascal-upper-matrix n)
  (for/list ((i n)) (for/list ((j n)) (j . binomial . i))))

(define (pascal-lower-matrix n)
  (for/list ((i n)) (for/list ((j n)) (i . binomial . j))))

(define (pascal-symmetric-matrix n)
  (for/list ((i n)) (for/list ((j n)) ((+ i j) . binomial . j))))

(define (matrix->string m)
  (define col-width
    (for*/fold ((rv 1)) ((r m) (c r))
      (if (zero? c) rv (max rv (+ 1 (order-of-magnitude c))))))
  (string-append
   (string-join
   (for/list ((r m))
     (string-join (map (λ (c) (~a #:width col-width #:align 'right c)) r) " ")) "\n")
   "\n"))

(printf "Upper:~%~a~%" (matrix->string (pascal-upper-matrix 5)))
(printf "Lower:~%~a~%" (matrix->string (pascal-lower-matrix 5)))
(printf "Symmetric:~%~a~%" (matrix->string (pascal-symmetric-matrix 5)))
