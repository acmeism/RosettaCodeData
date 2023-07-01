(defun write-sexp (sexp)
  "Writes a Lisp s-expression in square bracket notation."
  (labels ((parse (sexp)
	     (cond ((null sexp) "")
		   ((atom sexp) (format nil "~s " sexp))
		   ((listp sexp)
		    (concatenate
		     'string
		     (if (listp (car sexp))
			 (concatenate 'string "["
				      (fix-spacing (parse (car sexp)))
				      "] ")
			 (parse (car sexp)))
		     (parse (cdr sexp))))))
	   (fix-spacing (str)
	     (let ((empty-string ""))
	       (unless (null str)
		 (if (equal str empty-string)
		     empty-string
		     (let ((last-char (1- (length str))))
		       (if (eq #\Space (char str last-char))
			   (subseq str 0 last-char)
			   str)))))))
    (concatenate 'string "[" (fix-spacing (parse sexp)) "]")))
