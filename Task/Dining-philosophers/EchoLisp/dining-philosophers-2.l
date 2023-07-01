(define (observe dummmy)
		(writeln 'observer 'rounds= rounds)
		#t)
(define observer (make-task observe #t ))

(define (dinner)
	(task-run observer 5000)
	(for ((t tasks)) (task-run t)))

(dinner)
