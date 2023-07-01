(defun walk-directory (directory pattern)
  (directory (merge-pathnames pattern directory)))
