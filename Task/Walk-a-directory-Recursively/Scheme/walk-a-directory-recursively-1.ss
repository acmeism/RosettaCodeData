(use posix)
(use files)
(use srfi-13)

(define (walk FN PATH)
  (for-each (lambda (ENTRY)
    (cond ((not (null? ENTRY))

	   (let ((MYPATH (make-pathname PATH ENTRY)))

	     (cond ((directory-exists? MYPATH)
		    (walk FN MYPATH) ))

	     (FN MYPATH) )))) (directory PATH #t) ))

(walk (lambda (X) (cond ((string-suffix? ".scm" X) (display X)(newline) ))) "/home/user/")
