(let ((num (1+ (random 10))))
   (princ "Guess the no")
  (loop
   (setq guess (read))
     (if (eq guess num)
	 (progn(princ-list "Guess was right! " num) (return)) (print "Wrong, try again.") ) ) )
