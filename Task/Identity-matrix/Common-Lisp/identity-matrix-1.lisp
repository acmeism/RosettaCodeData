(defun make-identity-matrix (n)
  (let ((array (make-array (list n n) :initial-element 0)))
    (loop for i below n do (setf (aref array i i) 1))
    array))
