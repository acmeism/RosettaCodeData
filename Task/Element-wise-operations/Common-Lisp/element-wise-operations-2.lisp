(defun element-wise-scalar (fn A c)
  (let* ((len (array-total-size A))
         (m   (car (array-dimensions A)))
         (n   (cadr (array-dimensions A)))
         (B   (make-array `(,m ,n) :initial-element 0.0d0)))

    (loop for i from 0 to (1- len) do
         (setf (row-major-aref B i)
               (funcall fn
                        (row-major-aref A i)
                        c)))
    B))

;; c.+A, A.-c, c.*A, A./c, A.^c.
(defun .+ (c A) (element-wise-scalar #'+    A c))
(defun .- (A c) (element-wise-scalar #'-    A c))
(defun .* (c A) (element-wise-scalar #'*    A c))
(defun ./ (A c) (element-wise-scalar #'/    A c))
(defun .^ (A c) (element-wise-scalar #'expt A c))
