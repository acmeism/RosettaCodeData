(require 'sequences)
(require 'tasks)

;; inter-tasks message : (op-code . data)
(define (is-message? op message)
	(and message (equal? op (first message))))

;; reader task
(define (reader infile )
	(wait S)
	(define message (semaphore-pop S))
	(when (is-message? 'count message ) (writeln 'reader-> message) (task-stop-all))
	
	(if (first infile) ;; not EOF
	(set! message (cons 'write (next infile)))
	(set! message (list 'reader-count-please)))
	
	(semaphore-push S message)
	(signal S)
	infile)
	
(define (writer count)
	(wait S)
	(define message (semaphore-pop S))
	(when  (is-message? 'write message )
			(writeln (rest message))
			(set! count (1+ count))
			(set! message (cons 'ack count)))
	
	(when  (is-message? 'reader-count-please message )
		 (set! message (cons 'count count)))
	(semaphore-push S message)
	(signal S)
	count)
