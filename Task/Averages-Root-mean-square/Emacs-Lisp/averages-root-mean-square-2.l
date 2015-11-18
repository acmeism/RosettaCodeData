(defun rms (nums)
  (setq nums (mapcar 'float nums))
  (sqrt (/ (apply '+ (cl-map 'list '* nums nums))
	   (length nums))))

(rms (number-sequence 1 10))
