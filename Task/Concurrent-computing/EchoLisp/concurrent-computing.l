(lib 'tasks) ;; use the tasks library

(define (tprint line ) ;; task definition
		(writeln _TASK  line)
		#f )
		
(for-each  task-run ;; run three // tasks
      (map (curry make-task tprint) '(Enjoy Rosetta code )))

   →
   #task:id:66:running     Rosetta
   #task:id:67:running     code
   #task:id:65:running     Enjoy
