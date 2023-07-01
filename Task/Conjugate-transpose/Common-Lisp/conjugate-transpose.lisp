(defun matrix-multiply (m1 m2)
 (mapcar
  (lambda (row)
   (apply #'mapcar
    (lambda (&rest column)
     (apply #'+ (mapcar #'* row column))) m2)) m1))

(defun identity-p (m &optional (tolerance 1e-6))
 "Is m an identity matrix?"
  (loop for row in m
    for r = 1 then (1+ r) do
      (loop for col in row
        for c = 1 then (1+ c) do
          (if (eql r c)
            (unless (< (abs (- col 1)) tolerance) (return-from identity-p nil))
            (unless (< (abs col) tolerance) (return-from identity-p nil)) )))
  T )

(defun conjugate-transpose (m)
  (apply #'mapcar #'list (mapcar #'(lambda (r) (mapcar #'conjugate r)) m)) )

(defun hermitian-p (m)
  (equalp m (conjugate-transpose m)))

(defun normal-p (m)
  (let ((m* (conjugate-transpose m)))
    (equalp (matrix-multiply m m*) (matrix-multiply m* m)) ))

(defun unitary-p (m)
  (identity-p (matrix-multiply m (conjugate-transpose m))) )
