(defun perfectp (n)
  (= n (loop for i from 1 below n when (= 0 (mod n i)) sum i)))
