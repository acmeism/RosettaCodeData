(defun repeat-string (n string)
  (with-output-to-string (stream)
    (loop repeat n do (write-string string stream))))
