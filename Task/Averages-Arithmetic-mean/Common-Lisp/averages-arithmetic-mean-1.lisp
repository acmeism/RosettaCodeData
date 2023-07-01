(defun mean (&rest sequence)
  (when sequence
    (/ (reduce #'+ sequence) (length sequence))))
