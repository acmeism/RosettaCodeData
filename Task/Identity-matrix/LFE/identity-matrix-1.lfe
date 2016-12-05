(defun identity
  ((`(,m ,n))
   (identity m n))
  ((m)
   (identity m m)))

(defun identity (m n)
  (lists:duplicate m (lists:duplicate n 1)))
