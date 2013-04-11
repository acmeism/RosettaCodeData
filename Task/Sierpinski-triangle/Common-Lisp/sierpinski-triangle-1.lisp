(defun print-sierpinski (order)
  (loop with size = (expt 2 order)
        repeat size
        for v = (expt 2 (1- size)) then (logxor (ash v -1) (ash v 1))
        do (fresh-line)
           (loop for i below (integer-length v)
                 do (princ (if (logbitp i v) "*" " ")))))
