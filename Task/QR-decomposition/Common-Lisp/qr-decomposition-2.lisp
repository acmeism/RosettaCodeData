(defun make-householder (a)
  (let* ((m    (car (array-dimensions a)))
         (s    (sign (aref a 0 0)))
         (e    (make-unit-vector m))
         (u    (m+ a (.* (* (norm a) s) e)))
         (v    (./ u (aref u 0 0)))
         (beta (/ 2 (aref (mmul (mtp v) v) 0 0))))

    (m- (eye m)
        (.* beta (mmul v (mtp v))))))

(defun qr (A)
  (let* ((m (car  (array-dimensions A)))
         (n (cadr (array-dimensions A)))
         (Q (eye m)))

    ;; Work on n columns of A.
    (loop for i from 0 to (if (= m n) (- n 2) (- n 1)) do

         ;; Select the i-th submatrix. For i=0 this means the original matrix A.
         (let* ((B (array-range A i (1- m) i (1- n)))
                ;; Take the first column of the current submatrix B.
                (x (mcol B 0))
                ;; Create the Householder matrix for the column and embed it into an mxm identity.
                (H (array-embed (eye m) (make-householder x) i i)))

           ;; The product of all H matrices from the right hand side is the orthogonal matrix Q.
           (setf Q (mmul Q H))

           ;; The product of all H matrices with A from the LHS is the upper triangular matrix R.
           (setf A (mmul H A))))

    ;; Return Q and R.
    (values Q A)))
