(defun wget-clisp (url)
    (ext:with-http-input (stream url)
        (loop for line = (read-line stream nil nil)
            while line
            do (format t "~a~%" line))))
