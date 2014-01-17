(defun fibonacci-recursive (n)
  (if (< n 2)
      n
     (+ (fibonacci-recursive (- n 2)) (fibonacci-recursive (- n 1)))))
