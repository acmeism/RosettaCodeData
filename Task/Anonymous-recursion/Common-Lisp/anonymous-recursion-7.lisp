(defun fib (n &optional (f1 0) (f2 1))
  (if (< n 0)
    (format t "Parameter must be >= 0")
    (if (zerop n)
      f1
      (fib (1- n) f2 (+ f1 f2)))))
