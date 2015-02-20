(defun prime2 (a)
  (and (> a 1)
       (loop for x from 2 to (sqrt a)
             never (zerop (% a x)))))
