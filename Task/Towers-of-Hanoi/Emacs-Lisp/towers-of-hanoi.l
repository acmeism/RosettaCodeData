(defun move (n from to via)
  (if (= n 1)
      (message "Move from %S to %S" from to)
    (move (- n 1) from via to)
    (message "Move from %S to %S" from to)
    (move (- n 1) via to from)))
