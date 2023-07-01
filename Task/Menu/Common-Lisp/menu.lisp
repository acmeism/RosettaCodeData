(defun select (prompt choices)
  (if (null choices)
    ""
    (do (n)
        ((and n (<= 0 n (1- (length choices))))
         (nth n choices))
      (format t "~&~a~%" prompt)
      (loop for n from 0
            for c in choices
            do (format t "  ~d) ~a~%" n c))
      (force-output)
      (setf n (parse-integer (read-line *standard-input* nil)
                             :junk-allowed t)))))
