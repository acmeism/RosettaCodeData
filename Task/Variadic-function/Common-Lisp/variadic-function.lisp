(defun example (&rest args)
  (dolist (arg args)
    (print arg)))

(example "Mary" "had" "a" "little" "lamb")

(let ((args '("Mary" "had" "a" "little" "lamb")))
  (apply #'example args))
