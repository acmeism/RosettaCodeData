(defun test-sleep ()
  (let ((seconds (read)))
    (format t "Sleeping...~%")
    (sleep seconds)
    (format t "Awake!~%")))

(test-sleep)
