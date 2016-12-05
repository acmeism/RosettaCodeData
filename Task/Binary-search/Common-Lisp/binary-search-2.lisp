(defun binary-search (value array &optional (low 0) (high (1- (length array))))
  (if (< high low)
      nil
      (let ((middle (floor (+ low high) 2)))

        (cond ((> (aref array middle) value)
               (binary-search value array low (1- middle)))

              ((< (aref array middle) value)
               (binary-search value array (1+ middle) high))

              (t middle)))))
