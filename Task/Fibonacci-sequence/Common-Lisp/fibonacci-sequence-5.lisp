(defun fibonacci-tail-recursive ( n &optional (a 0) (b 1))
  (if (= n 0)
      a
      (fibonacci-tail-recursive (- n 1) b (+ a b))))
