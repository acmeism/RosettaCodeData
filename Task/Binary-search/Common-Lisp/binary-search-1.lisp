(defun binary-search (value array)
  (let ((low 0)
        (high (1- (length array))))

    (do () ((< high low) nil)
      (let ((middle (floor (+ low high) 2)))

        (cond ((> (aref array middle) value)
               (setf high (1- middle)))

              ((< (aref array middle) value)
               (setf low (1+ middle)))

              (t (return middle)))))))
