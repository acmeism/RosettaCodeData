(defun read-nth-line (file n &aux (line-number 0))
  "Read the nth line from a text file. The first line has the number 1"
  (assert (> n 0) (n))
  (with-open-file (stream file)
    (loop for line = (read-line stream nil nil)
          if (and (null line) (< line-number n))
            do (error "file ~a is too short, just ~a, not ~a lines long"
                      file line-number n)
          do (incf line-number)
          if (and line (= line-number n))
            do (return line))))
