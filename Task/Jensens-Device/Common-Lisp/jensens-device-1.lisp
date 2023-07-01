(declaim (inline %sum))

(defun %sum (lo hi func)
  (loop for i from lo to hi sum (funcall func i)))

(defmacro sum (i lo hi term)
  `(%sum ,lo ,hi (lambda (,i) ,term)))
