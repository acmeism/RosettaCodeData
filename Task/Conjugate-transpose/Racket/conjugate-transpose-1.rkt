#lang racket
(require math)
(define H matrix-hermitian)

(define (normal? M)
  (define MH (H M))
  (equal? (matrix* MH M)
          (matrix* M MH)))

(define (unitary? M)
  (define MH (H M))
  (and (matrix-identity? (matrix* MH M))
       (matrix-identity? (matrix* M MH))))

(define (hermitian? M)
  (equal? (H M) M))
