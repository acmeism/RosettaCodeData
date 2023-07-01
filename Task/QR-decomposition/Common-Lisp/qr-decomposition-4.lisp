(defun polyfit (x y n)
  (let* ((m (cadr (array-dimensions x)))
         (A (make-array `(,m ,(+ n 1)) :initial-element 0)))
    (loop for i from 0 to (- m 1) do
          (loop for j from 0 to n do
                (setf (aref A i j)
                      (expt (aref x 0 i) j))))
    (lsqr A (mtp y))))

;; Solve a linear least squares problem by QR decomposition.
(defun lsqr (A b)
  (multiple-value-bind (Q R) (qr A)
    (let* ((n (cadr (array-dimensions R))))
      (solve-upper-triangular (array-range R                0 (- n 1) 0 (- n 1))
                              (array-range (mmul (mtp Q) b) 0 (- n 1) 0 0)))))

;; Solve an upper triangular system by back substitution.
(defun solve-upper-triangular (R b)
  (let* ((n (cadr (array-dimensions R)))
         (x (make-array `(,n 1) :initial-element 0.0d0)))

    (loop for k from (- n 1) downto 0
       do (setf (aref x k 0)
                (/ (- (aref b k 0)
                      (loop for j from (+ k 1) to (- n 1)
                         sum (* (aref R k j)
                                (aref x j 0))))
                   (aref R k k))))
    x))
