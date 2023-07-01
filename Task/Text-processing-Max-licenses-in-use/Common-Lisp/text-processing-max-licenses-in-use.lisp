(defun max-licenses (&optional (logfile "mlijobs.txt"))
  (with-open-file (log logfile :direction :input)
    (do ((current-logs 0) (max-logs 0) (max-log-times '())
         (line #1=(read-line log nil nil) #1#))
        ((null line)
         (format t "~&Maximum simultaneous license use is ~w at the ~
                     following time~p: ~{~%  ~a~}."
                 max-logs (length max-log-times) (nreverse max-log-times)))
      (cl-ppcre:register-groups-bind (op time)
          ("License (\\b.*\\b)[ ]{1,2}@ (\\b.*\\b)" line)
        (cond ((string= "OUT" op) (incf current-logs))
              ((string= "IN"  op) (decf current-logs))
              (t (cerror "Ignore it." "Malformed entry ~s." line)))
        (cond ((> current-logs max-logs)
               (setf max-logs current-logs
                     max-log-times (list time)))
              ((= current-logs max-logs)
               (push time max-log-times)))))))
