(defun forward-difference (list)
  (mapcar #'- (rest list) list))

(defun nth-forward-difference (list n)
  (setf list (copy-list list))
  (loop repeat n do (map-into list #'- (rest list) list))
  (subseq list 0 (- (length list) n)))
