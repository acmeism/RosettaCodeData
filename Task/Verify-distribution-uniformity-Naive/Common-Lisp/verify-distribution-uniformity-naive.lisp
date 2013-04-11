(defun check-distribution (function n &optional (delta 1.0))
  (let ((bins (make-hash-table)))
    (loop repeat n do (incf (gethash (funcall function) bins 0)))
    (loop with target = (/ n (hash-table-count bins))
          for key being each hash-key of bins using (hash-value value)
          when (> (abs (- value target)) (* 0.01 delta n))
          do (format t "~&Distribution potentially skewed for ~w:~
                         expected around ~w got ~w." key target value)
          finally (return bins))))
