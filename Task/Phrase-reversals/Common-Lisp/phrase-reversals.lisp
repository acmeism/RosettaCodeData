(defun split-string (str)
 "Split a string into space separated words including spaces"
  (do* ((lst nil)
        (i (position-if #'alphanumericp str) (position-if #'alphanumericp str :start j))
        (j (when i (position #\Space str :start i)) (when i (position #\Space str :start i))) )
       ((null j) (nreverse (push (subseq str i nil) lst)))
    (push (subseq str i j) lst)
    (push " " lst) ))


(defun task (str)
  (print (reverse str))
  (let ((lst (split-string str)))
    (print (apply #'concatenate 'string (mapcar #'reverse lst)))
    (print (apply #'concatenate 'string (reverse lst))) )
  nil )
