(defun factorial
  ((n) (when (== n 0)) 1)
  ((n) (when (> n 0))
    (* n (factorial (- n 1)))))
