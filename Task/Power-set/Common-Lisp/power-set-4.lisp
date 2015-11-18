(defun powerset (xs)
  (loop for i below (expt 2 (length xs)) collect
       (loop for j below i for x in xs if (logbitp j i) collect x)))
