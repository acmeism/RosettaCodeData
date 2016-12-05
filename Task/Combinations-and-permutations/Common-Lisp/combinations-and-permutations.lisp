(defun combinations (n k)
  (let ((num 1)
        (den 1) )
    (dotimes (i k (/ num den))
      (setq num (* num (- n i)) den (* den (- k i))) )))


(defun permutations (n k)
  (let ((p 1))
    (dotimes (i k p)
      (setq p (* p (- n i))) )))
