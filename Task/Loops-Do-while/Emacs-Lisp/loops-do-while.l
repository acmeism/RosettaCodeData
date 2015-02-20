(let ((val 0))
  (while (progn
           (setq val (1+ val))
           (message "%d" val)
           (/= 0 (mod val 6)))))
