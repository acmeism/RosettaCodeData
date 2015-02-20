(defun rms (nums)
  ;; `/' returns a float only when given floats
  (setq nums (mapcar 'float nums))
  (sqrt (/ (apply '+ (mapcar (lambda (x) (* x x)) nums))
	   (length nums))))
