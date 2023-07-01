(defun wait_10 ()
  (catch 'loop-break
    (while 't
      (let ((math (random 19)))
	(if (= math 10)
	    (progn  (message "Found value: %d" math)
		    (throw 'loop-break math))
	  (message "current number is: %d" math) ) ) ) ) )

(wait_10)
