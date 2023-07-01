(defun list< (a b)
  (let ((x (find-if-not #'zerop (mapcar #'- a b))))
    (if x (minusp x) (< (length a) (length b)))))
