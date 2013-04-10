(defun count-sub (str pat)
  (loop with z = 0 with s = 0 while s do
	(when (setf s (search pat str :start2 s))
	  (incf z) (incf s (length pat)))
	finally (return z)))

(count-sub "ababa" "ab")  ; 2
(count-sub "ababa" "aba") ; 1
