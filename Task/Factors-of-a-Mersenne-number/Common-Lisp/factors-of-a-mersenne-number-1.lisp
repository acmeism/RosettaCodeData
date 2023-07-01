(defun mersenne-fac (p &aux (m (1- (expt 2 p))))
  (loop for k from 1
        for n = (1+ (* 2 k p))
        until (zerop (mod m n))
        finally (return n)))

(print (mersenne-fac 929))
