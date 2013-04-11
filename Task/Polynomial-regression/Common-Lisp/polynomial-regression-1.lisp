;; Least square fit of a polynomial of order n the x-y-curve.
(defun polyfit (x y n)
  (let* ((m (cadr (array-dimensions x)))
         (A (make-array `(,m ,(+ n 1)) :initial-element 0)))
    (loop for i from 0 to (- m 1) do
          (loop for j from 0 to n do
                (setf (aref A i j)
                      (expt (aref x 0 i) j))))
    (lsqr A (mtp y))))
