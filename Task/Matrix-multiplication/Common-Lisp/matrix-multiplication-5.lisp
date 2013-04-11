(defun mmult (a b)
  (loop
       with m = (array-dimension a 0)
       with n = (array-dimension a 1)
       with l = (array-dimension b 1)
       with c = (make-array (list m l) :initial-element 0)
       for i below m do
              (loop for k below l do
                    (setf (aref c i k)
                          (loop for j below n
                                sum (* (aref a i j)
                                       (aref b j k)))))
       finally (return c)))
