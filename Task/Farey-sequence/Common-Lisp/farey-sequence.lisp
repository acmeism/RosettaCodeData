(defun farey (n)
  (labels ((helper (begin end)
	     (let ((med (/ (+ (numerator begin) (numerator end))
			   (+ (denominator begin) (denominator end)))))
	       (if (<= (denominator med) n)
		   (append (helper begin med)
			   (list med)
			   (helper med end))))))
      (append (list 0) (helper 0 1) (list 1))))


;; Force printing of integers in X/1 format
(defun print-ratio (stream object &optional colonp at-sign-p)
  (format stream "~d/~d" (numerator object) (denominator object)))

(loop for i from 1 to 11 do
     (format t "~a: ~{~/print-ratio/ ~}~%" i (farey i)))

(loop for i from 100 to 1001 by 100 do
     (format t "Farey sequence of order ~a has ~a terms.~%" i (length (farey i))))
