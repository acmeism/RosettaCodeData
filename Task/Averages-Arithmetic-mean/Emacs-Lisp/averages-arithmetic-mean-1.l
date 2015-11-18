  (defun mean (lst)
    (/ (float (apply '+ lst)) (length lst)))
  (mean '(1 2 3 4))
