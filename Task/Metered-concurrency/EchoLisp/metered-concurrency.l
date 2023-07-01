(require 'tasks) ;; tasks library

(define (task id)
	(wait S) ;; acquire, p-op
	(printf "task %d acquires semaphore @ %a" id (date->time-string (current-date)))
	(sleep 2000)
	(signal S) ;; release, v-op
	id)
	
(define S (make-semaphore 4)) ;; semaphore with init count 4

;; run 10 // tasks
(for ([i 10]) (task-run (make-task task i ) (random 500)))
