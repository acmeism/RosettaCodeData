(defun sleeprint(n)
    (sleep (/ n 10))
    (format t "~a~%" n))

(loop for arg in (cdr sb-ext:*posix-argv*) doing
      (sb-thread:make-thread (lambda() (sleeprint (parse-integer arg)))))

(loop while (not (null (cdr (sb-thread:list-all-threads)))))
