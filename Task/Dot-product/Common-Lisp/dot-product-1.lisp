(defun dot-product (a b)
  (apply #'+ (mapcar #'* (coerce a 'list) (coerce b 'list))))
