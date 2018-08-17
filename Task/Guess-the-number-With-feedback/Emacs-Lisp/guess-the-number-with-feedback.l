(let ((num (1+ (random 100))))
  (princ "Guess the no: ")
  (loop
   (setq guess (read))
   (cond
    ((not (numberp guess)) (print "Please enter a number"))
   ((eq guess num)
       (progn (princ-list "Guess was right! " num)
	      (return)))
     ((> guess num)
      (print "Too High!"))
     ((< guess num)
       (print "Too low!"))) ) )
