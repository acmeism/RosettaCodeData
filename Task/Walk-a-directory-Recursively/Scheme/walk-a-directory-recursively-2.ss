(use file.util)
(use srfi-13)

(define (walk FN PATH)
  (for-each (lambda (ENTRY)
    (cond ((not (null? ENTRY))
	   (let ((MYPATH ENTRY))

	     (cond ((file-is-directory? MYPATH)
		    (walk FN MYPATH) ))
	
	     (FN MYPATH) )))) (directory-list PATH :add-path? #t :children? #t ) ))

(walk (lambda (X) (cond ((string-suffix? ".scm" X) (display X)(newline) ))) "/home/user/")
