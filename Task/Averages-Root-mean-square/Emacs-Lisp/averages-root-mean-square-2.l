(defun rms (nums)
  (setq nums (mapcar 'float nums))
  (sqrt (/ (apply '+ (cl-map 'list '* nums nums))
	   (length nums))))

(rms '(1 2 3 4 5 6 7 8 9 10))
