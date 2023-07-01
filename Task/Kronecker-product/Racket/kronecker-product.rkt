#lang typed/racket/base

(require math/array
         math/matrix
         racket/match)

(define-type (M A) (Matrix A))

(define #:forall (A B C) (general-⊗ [m1 : (M A)] [m2 : (M B)] [× : (A B -> C)]) : (M C)
  (match-let* ((`(#(,rs1 ,cs1) . #(,rs2 ,cs2)) (cons (array-shape m1) (array-shape m2)))
               (rs (* rs1 rs2))
               (cs (* cs1 cs2)))
    (for*/matrix: rs cs ((r (in-range rs)) (c (in-range cs))) : C
      (let-values (((rq rr) (quotient/remainder r rs2))
                   ((cq cr) (quotient/remainder c cs2)))
        (× (array-ref m1 (vector rq cq)) (array-ref m2 (vector rr cr)))))))

;; Narrow to Number
(define (Kronecker-product [m1 : (M Number)] [m2 : (M Number)]) (general-⊗ m1 m2 *))

;; ---------------------------------------------------------------------------------------------------
(module+ test
  (Kronecker-product (matrix [[1 2]
                              [3 4]])
                     (matrix [[0 5]
                              [6 7]]))

  (Kronecker-product (matrix [[0 1 0]
                              [1 1 1]
                              [0 1 0]])
                     (matrix [[1 1 1 1]
                              [1 0 0 1]
                              [1 1 1 1]])))
