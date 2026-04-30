(import srfi/231)

(define (Cholesky A)
  ;; Assumes the domain of A is [0,n)\\times [0,n)
  (let ((n  (interval-upper-bound (array-domain A) 0))
        (A_ (array-getter A))
        (A! (array-setter A)))
    (do ((i 0 (+ i 1)))
        ((= i n) A)
      (let* ((pivot (sqrt (A_ i i)))
             (column/row-domain
              ;; both will be one-dimensional
              (make-interval (vector (+ i 1)) (vector n)))
             (column
              ;; the column below the (i,i) entry
              (specialized-array-share A
                                       column/row-domain
                                       (lambda (k) (values k i))))
             (row
              ;; the row to the right of the (i,i) entry
              (specialized-array-share A
                                       column/row-domain
                                       (lambda (k) (values i k))))
             (subarray
              ;; the subarray to the right and below the (i,i) entry
              (array-extract A (make-interval (vector (+ i 1) (+ i 1)) (vector n n)))))
        ;; set diagonal value
        (A! pivot i i)
        ;; compute multipliers
        (array-assign! column (array-map (lambda (x) (/ x pivot)) column))
        ;; zero the rest of the ith row, preserving exactness
        (array-assign! row (make-array column/row-domain
                                       ;; a zero with the same exactness as pivot
                                       (lambda (j) (- pivot pivot))))
        ;; subtract the outer product of i'th
        ;; row and column from the subarray
        (array-assign! subarray
                       (array-map -
                                  subarray
                                  (array-outer-product * column column)))))))

(define Example-1
  (list*->array 2 '((25 15 -5)
                    (15 18  0)
                    (-5  0 11))))

(define Example-2
  (list*->array 2 '((18 22 54 42)
                    (22 70 86 62)
                    (54 86 174 134)
                    (42 62 134 106))))

(pretty-print (array->list* (Cholesky Example-1)))
(newline)
(pretty-print (array->list* (Cholesky Example-2)))
