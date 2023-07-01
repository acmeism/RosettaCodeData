(defun kill (n k &aux (m 0))
  (loop for a from (1+ m) upto n do
        (setf m (mod (+ m k) a)))
  m)
