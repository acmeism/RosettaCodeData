(defun main ()
  (with-open-file (stream "/dev/lp0"
    :direction :output
    :if-exists :append)
    (format stream "Hello World~%")))
(main)
