(with-open-file (input "file.txt")
   (loop for line = (read-line input nil)
      while line do (format t "~a~%" line)))
