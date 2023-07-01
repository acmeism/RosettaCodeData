(defun jort-sort (x)
  (equalp x (sort (copy-seq x) #'<)))
