(defun mean (list)
  (unless (null list)
    (/ (loop for i in list sum i)
       (length list))))
