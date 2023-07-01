(defun strings-equal-p (strings)
  (null (remove (first strings) (rest strings) :test #'string=)))

(defun strings-ascending-p (strings)
  (loop for string1 = (first strings) then string2
        for string2 in (rest strings)
        always (string-lessp string1 string2)))
