(defun luhn (n)
  (labels ((sum-digits (n) (if (> n 9) (- n 9) n)))
    (let ((n* (reverse n)) (l (length n)))
      (let ((s1 (loop for i from 0 below l by 2
		   summing (digit-char-p (aref n* i))))
	    (s2 (loop for i from 1 below l by 2
		   summing (sum-digits (* 2 (digit-char-p (aref n* i)))))))
	(zerop (mod (+ s1 s2) 10))))))
