;; Solve a linear system AX=B where A is symmetric and positive definite, so it can be Cholesky decomposed.
(defun linsys (A B)
  (let* ((n (car  (array-dimensions A)))
         (m (cadr (array-dimensions B)))
         (y (make-array n        :element-type 'long-float :initial-element 0.0L0))
         (X (make-array `(,n ,m) :element-type 'long-float :initial-element 0.0L0))
         (L (chol A))) ; A=LL'

    (loop for col from 0 to (- m 1) do
       ;; Forward substitution: y = L\B
       (loop for k from 0 to (- n 1)
             do (setf (aref y k)
                      (/ (- (aref B k col)
                            (loop for j from 0 to (- k 1)
                                  sum (* (aref L k j)
                                         (aref y j))))
                         (aref L k k))))

       ;; Back substitution. x=L'\y
       (loop for k from (- n 1) downto 0
             do (setf (aref X k col)
                      (/ (- (aref y k)
                            (loop for j from (+ k 1) to (- n 1)
                                  sum (* (aref L j k)
                                         (aref X j col))))
                         (aref L k k)))))
    X))

;; Solve a linear least squares problem. Ax=b, with A being mxn, with m>n.
;; Solves the linear system A'Ax=A'b.
(defun lsqr (A b)
  (linsys (mmul (mtp A) A)
          (mmul (mtp A) b)))
