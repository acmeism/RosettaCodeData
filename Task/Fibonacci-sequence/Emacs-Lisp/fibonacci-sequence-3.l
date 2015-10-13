(insert
 (mapconcat '(lambda (n) (format "%d" (fibonacci n) ))
	    (number-sequence 0 15) " ") )
