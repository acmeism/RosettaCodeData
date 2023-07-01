(defun sum-3-5-fast (limit)
  (flet ((triangular (n) (truncate (* n (1+ n)) 2)))
    (let ((n (1- limit)))  ; Sum multiples *below* the limit
      (- (+ (* 3 (triangular (truncate n 3)))
            (* 5 (triangular (truncate n 5))))
         (* 15 (triangular (truncate n 15)))))))
