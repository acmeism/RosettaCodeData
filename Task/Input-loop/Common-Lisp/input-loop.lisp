(defun basic-input (filename)
    (with-open-file (stream (make-pathname :name filename) :direction :input)
        (loop for line = (read-line stream nil nil)
            while line
            do (format t "~a~%" line))))
