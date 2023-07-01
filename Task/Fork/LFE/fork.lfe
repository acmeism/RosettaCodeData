(defun start ()
  (spawn (lambda () (child))))

(defun child ()
  (lfe_io:format "This is the new process~n" '()))
