(defun prime3 (a)
  (and (> a 1)
       (or (= a 2) (oddp a))
       (loop for x from 3 to (sqrt a) by 2
             never (zerop (% a x)))))
