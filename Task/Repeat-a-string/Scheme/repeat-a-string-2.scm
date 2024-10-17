(define (string-repeat n str)
	(fold string-append "" (make-list n str)))
(string-repeat 5 "ha") ==> "hahahahaha"
