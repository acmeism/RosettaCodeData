(defun curry (function &rest args-1)
  (lambda (&rest args-2)
    (apply function (append args-1 args-2))))
