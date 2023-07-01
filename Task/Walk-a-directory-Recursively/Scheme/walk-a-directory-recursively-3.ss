#lang scheme

(require srfi/13)

(define (walk FN PATH)
  (for-each (lambda (ENTRY)
    (cond ((not (null? ENTRY))

	   (let ((MYPATH (build-path PATH ENTRY)))

	     (cond ((directory-exists? MYPATH)
		    (walk FN MYPATH) ))
	
	     (FN MYPATH) )))) (directory-list PATH)))

(walk (lambda (X) (cond ((string-suffix? ".scm" (path->string X)) (display X)(newline) ))) "/home/user/")
