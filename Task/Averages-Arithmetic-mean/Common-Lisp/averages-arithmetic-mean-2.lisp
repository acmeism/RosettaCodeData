(defun mean (list)
  (when list
    (/ (loop for i in list sum i)
       (length list))))
