(require 'cl-lib)

(defun transpose (m)
  (apply #'cl-mapcar #'list m))

;;test for transposition function
(transpose '((2 3 4 5) (3 5 6 9) (9 9 9 9)))
