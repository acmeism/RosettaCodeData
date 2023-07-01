(defun repeat-string (n string)
  (format nil "~V@{~a~:*~}" n string))
