(defun identity-matrix (n)
  (loop for a from 1 to n
        collect (loop for e from 1 to n
                      if (= a e) collect 1
                      else collect 0)))
