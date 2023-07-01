(defun repeat (f n)
  (dotimes (i n) (funcall f)))

(repeat (lambda () (format T "Example~%")) 5)
