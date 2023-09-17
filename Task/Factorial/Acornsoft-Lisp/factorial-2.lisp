(defun factorial (n (result . 1))
  (loop
    (until (zerop n) result)
    (setq result (times n result))
    (setq n (sub1 n))))
