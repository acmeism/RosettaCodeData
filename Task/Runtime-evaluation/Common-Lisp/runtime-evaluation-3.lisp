(defun add-four-by-function (a-number)
  (funcall (eval '(lambda (n) (+ 4 n)))) a-number)
