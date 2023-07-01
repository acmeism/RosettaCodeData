(let* ((integer-width (* 65536 16)) ; raise bignum limit from 65536 bits to avoid overflow error
       (answer (number-to-string (expt 5 (expt 4 (expt 3 2)))))
       (length (length answer)))
  (message "%s has %d digits"
	   (if (> length 40)
	       (format "%s...%s"
		       (substring answer 0 20)
		       (substring answer (- length 20) length))
	     answer)
	   length))
