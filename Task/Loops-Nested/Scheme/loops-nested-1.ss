(call-with-current-continuation
 (lambda (return)
   (for-each (lambda (a)
	       (for-each (lambda (b)
			   (cond ((= 20 b)
				  (newline)
				  (return))
				 (else
				  (display " ")(display b))))
			 a)
	       (newline))
	     array)))
