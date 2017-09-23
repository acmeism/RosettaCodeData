(defparameter *shrink* 1.3)

(defun comb-sort (input)
  (loop with input-size = (length input)
        with gap = input-size
        with swapped
        do (when (> gap 1)
             (setf gap (floor gap *shrink*)))
           (setf swapped nil)
           (loop for lo from 0
                 for hi from gap below input-size
                 when (> (aref input lo) (aref input hi))
                   do (rotatef (aref input lo) (aref input hi))
                      (setf swapped t))
        while (or (> gap 1) swapped)
        finally (return input)))
