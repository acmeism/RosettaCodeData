(defun rms (nums)
  (sqrt (/ (apply '+ (mapcar (lambda (x) (* x x)) nums))
           (float (length nums)))))

(rms (number-sequence 1 10))
