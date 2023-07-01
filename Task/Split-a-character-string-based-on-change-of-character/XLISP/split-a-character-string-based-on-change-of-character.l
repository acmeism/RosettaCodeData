(defun delimit (s)
	(defun delim (old-list new-list current-char)
		(if (null old-list)
			new-list
			(delim (cdr old-list) (append new-list
				(if (not (equal (car old-list) current-char))
					`(#\, #\Space ,(car old-list))
					(cons (car old-list) nil) ) )
			(car old-list) ) ) )
	(list->string (delim (string->list s) '() (car (string->list s)))) )

(display (delimit "gHHH5YY++///\\")) ;; NB. The "\" character needs to be escaped
