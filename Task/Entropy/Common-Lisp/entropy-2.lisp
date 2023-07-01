(defun entropy (string &aux (length (length string)))
  (declare (type string string))
  (let ((table (make-hash-table)))
    (loop for char across string
          do (incf (gethash char table 0)))
    (- (loop for freq being each hash-value in table
             for freq/length = (/ freq length)
             sum (* freq/length (log freq/length 2))))))
