(defun lexicographic-sort (n)
  (sort (alexandria:iota n :start 1) #'string<= :key #'write-to-string))
(lexicographic-sort 13)
