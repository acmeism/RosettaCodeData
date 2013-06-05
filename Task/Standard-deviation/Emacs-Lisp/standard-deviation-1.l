(defun running-std (x)
  ; ensure that we have a float to avoid potential integer math errors.
  (setq x (float x))
  ; define variables to use
  (defvar running-sum 0 "the running sum of all known values")
  (defvar running-len 0 "the running number of all known values")
  (defvar running-squared-sum 0 "the running squared sum of all known values")
  ; and make them local to this buffer
  (make-local-variable 'running-sum)
  (make-local-variable 'running-len)
  (make-local-variable 'running-squared-sum)
  ; now process the new value
  (setq running-sum (+ running-sum x))
  (setq running-len (1+ running-len))
  (setq running-squared-sum (+ running-squared-sum (* x x)))
  ; and calculate the new standard deviation
  (sqrt (- (/ running-squared-sum
              running-len) (/ (* running-sum running-sum)
                                 (* running-len running-len )))))
