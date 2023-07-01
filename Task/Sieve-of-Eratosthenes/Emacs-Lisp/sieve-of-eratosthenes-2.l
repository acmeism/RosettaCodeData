(defun sieve (limit)
  (let ((xs (vconcat [0 0] (number-sequence 2 limit))))
    (cl-loop for i from 2 to (sqrt limit)
             when (aref xs i)
             do (cl-loop for m from (* i i) to limit by i
                         do (aset xs m 0)))
    (remove 0 xs)))
