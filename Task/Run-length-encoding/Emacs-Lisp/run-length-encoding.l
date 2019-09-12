(defun run-length-encode (str_arg)
  "Return the run length encoding of a string argument STR_ARG."

    (let ((dalist (string-to-list str_arg)) (letters) (frequency))

      (dolist (element dalist)
	(if (not (equal (car letters) element))
	    (progn
	      (setq letters (cons element letters))
	      (setq frequency (cons 1 frequency)))
	  (setq frequency (cons (+ (car frequency ) 1) (cdr frequency)))))

      (apply 'concat
	     (reverse
	      (mapcar*
	       (lambda (x y) (concat (number-to-string x)
				     (char-to-string y)))
	       frequency letters)))))
