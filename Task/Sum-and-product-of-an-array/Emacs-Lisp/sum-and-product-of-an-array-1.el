(let ((array [1 2 3 4 5]))
  (apply #'+ (append array nil))
  (apply #'* (append array nil)))
