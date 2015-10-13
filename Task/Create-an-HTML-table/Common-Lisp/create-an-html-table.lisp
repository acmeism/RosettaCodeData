(ql:quickload :closure-html)
(use-package :closure-html)
(serialize-lhtml
 `(table nil
	 (tr nil ,@(mapcar (lambda (x)
			     (list 'th nil x))
			   '("" "X" "Y" "Z")))
	 ,@(loop for i from 1 to 4
	      collect `(tr nil
			   (th nil ,(format nil "~a" i))
			   ,@(loop repeat 3 collect `(td nil ,(format nil "~a" (random 10000)))))))
 (make-string-sink))
