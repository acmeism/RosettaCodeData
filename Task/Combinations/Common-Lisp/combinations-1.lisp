(defun map-combinations (m n fn)
  "Call fn with each m combination of the integers from 0 to n-1 as a list. The list may be destroyed after fn returns."
  (let ((combination (make-list m)))
    (labels ((up-from (low)
               (let ((start (1- low)))
                 (lambda () (incf start))))
             (mc (curr left needed comb-tail)
               (cond
                ((zerop needed)
                 (funcall fn combination))
                ((= left needed)
                 (map-into comb-tail (up-from curr))
                 (funcall fn combination))
                (t
                 (setf (first comb-tail) curr)
                 (mc (1+ curr) (1- left) (1- needed) (rest comb-tail))
                 (mc (1+ curr) (1- left) needed comb)))))
      (mc 0 n m combination))))
