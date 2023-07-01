(defun element-wise-matrix (fn A B)
  (let* ((len (array-total-size A))
         (m   (car (array-dimensions A)))
         (n   (cadr (array-dimensions A)))
         (C   (make-array `(,m ,n) :initial-element 0.0d0)))

    (loop for i from 0 to (1- len) do
         (setf (row-major-aref C i)
               (funcall fn
                        (row-major-aref A i)
                        (row-major-aref B i))))
    C))

;; A.+B, A.-B, A.*B, A./B, A.^B.
(defun m+ (A B) (element-wise-matrix #'+    A B))
(defun m- (A B) (element-wise-matrix #'-    A B))
(defun m* (A B) (element-wise-matrix #'*    A B))
(defun m/ (A B) (element-wise-matrix #'/    A B))
(defun m^ (A B) (element-wise-matrix #'expt A B))
