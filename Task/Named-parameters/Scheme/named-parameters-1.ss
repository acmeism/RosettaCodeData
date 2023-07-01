(define (keyarg-parser argdefs args kont)
  (apply kont
	 (map (lambda (argdef)
		(let loop ((args args))
		  (cond ((null? args)
			 (cadr argdef))
			((eq? (car argdef) (car args))
			 (cadr args))
			(else
			 (loop (cdr args))))))
	      argdefs)))

(define (print-name . args)
  (keyarg-parser '((first #f)(last "?"))
		 args
		 (lambda (first last)
		   (display last)
		   (cond (first
			  (display ", ")
			  (display first)))
		   (newline))))
