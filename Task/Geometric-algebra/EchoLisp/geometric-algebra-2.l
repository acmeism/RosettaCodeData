;; we use indices (1 ... n) in conformity with the Wikipedia reference

;; dimension 2
;; (1 + e1e2) • (e1 -2e2) = -e1 -3e2
(make-cga 2 0)
(define u #(1 0 0 1))
(define v #(0 1 -2 0))

(multi-print u) → +1*1 +1*e1e2
(multi-print v) → +1*e1 -2*e2
(• u v)         → -1*e1 -3*e2

;; task
(make-cga 5 0)
(define X #(0 1 -1 0 2 0 0 0 -3 0 0 0 0 0 0 0 -2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))
(multi-print X) → +1*e1 -1*e2 +2*e3 -3*e4 -2*e5
(• X X)  →  +19*1

; with another polynomial
(make-cga 0 5)
Signature → #( 1 -1 -1 1 -1 1 1 1 -1 1 1 1 1 1 1 1 -1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
(• X X) → -19*1

;
(make-cga 4 0)
(define i (Eij 1 2))
(define j (Eij 2 3))
(define k (Eij 1 3))

(multi-print i) → +1*e1e2
(multi-print j) → +1*e2e3
(multi-print k)]→ +1*e1e3
(• i i) → -1*1
(• j j) → -1*1
(• k k) → -1*1
(• i j k) → -1*1

(define I (Eij 2 3))
😖️ error: define : cannot redefine : I (used in Complex) ;; use II instead

(define II (Eij 2 3)) → +1*e2e3
(define J (Eij 3 4)) → +1*e3e4
(define K (Eij 2 4)) → +1*e2e4

(• II II) → -1*1
(• J J)  → -1*1
(• K K)  → -1*1
(• II J K) → -1*1

