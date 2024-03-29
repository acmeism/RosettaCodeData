(defun sieve-set (limit)
  (let ((xs (make-vector (1+ limit) 0)))
    (cl-loop for i from 2 to limit
             when (zerop (aref xs i))
             collect i
             and do (cl-loop for m from (* i i) to limit by i
                             do (aset xs m 1)))))
