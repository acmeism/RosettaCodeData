(defun sieve-of-eratosthenes (maximum)
  (loop
     with sieve = (make-array (1+ maximum)
                              :element-type 'bit
                              :initial-element 0)
     for candidate from 2 to maximum
     when (zerop (bit sieve candidate))
     collect candidate
     and do (loop for composite from (expt candidate 2)
               to maximum by candidate
               do (setf (bit sieve composite) 1))))
