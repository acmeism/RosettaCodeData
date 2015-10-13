(defun sum-square (ls)
  (apply '+ (mapcar (lambda (k) (* k k) ) ls) ))

(insert (format "%d"(sum-square (number-sequence 0 3) )))
