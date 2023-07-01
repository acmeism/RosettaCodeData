(defun babbage-test (n)
 "A generic function for any ending of a number"
  (when (> n 0)
    (do* ((i 0 (1+ i))
          (d (expt 10 (1+ (truncate (log n) (log 10))))) )
      ((= (mod (* i i) d) n) i) )))
