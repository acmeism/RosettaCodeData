(let* ((answer (calc-eval "5**4**3**2"))
       (length (length answer)))
  (message "%s has %d digits"
	   (if (> length 40)
	       (format "%s...%s"
		       (substring answer 0 20)
		       (substring answer (- length 20) length))
	     answer)
	   length))
