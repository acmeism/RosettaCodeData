#lang racket
(require math/matrix math/array)
(define-values (T I col size)
  (values ; short names
   matrix-transpose identity-matrix matrix-col matrix-num-rows))

(define (scale c A) (matrix-scale A c))
(define (unit n i) (build-matrix n 1 (λ (j _) (if (= j i) 1 0))))

(define (H u)
  (matrix- (I (size u))
           (scale (/ 2 (matrix-dot u u))
                  (matrix* u (T u)))))

(define (normal a)
  (define a0 (matrix-ref a 0 0))
  (matrix- a (scale (* (sgn a0) (matrix-2norm a))
                    (unit (size a) 0))))

(define (QR A)
  (define n (size A))
  (for/fold ([Q (I n)] [R A]) ([i (- n 1)])
    (define Hi (H (normal (submatrix R (:: i n) (:: i (+ i 1))))))
    (define Hi* (if (= i 0) Hi (block-diagonal-matrix (list (I i) Hi))))
    (values (matrix* Q Hi*) (matrix* Hi* R))))

(QR (matrix [[12 -51   4]
               [ 6 167 -68]
               [-4  24 -41]]))
