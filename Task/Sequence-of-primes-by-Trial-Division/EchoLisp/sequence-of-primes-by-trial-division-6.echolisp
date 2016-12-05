(lib 'tasks)
(lib 'bigint)

(define (t-next-prime n)
		(define next
		(for ((p [n .. ] )) #:break (is-prime? p) =>  p ))
		(writeln next) ;; or whatever action here
		(1+ next)) ;; unbounded : return #f to stop or CTRL-C
		
		

(define t-primes (make-task t-next-prime 1_000_000_000_000))

(task-run t-primes)
   → #task:id:95:running
1000000000039
1000000000061
1000000000063
1000000000091
1000000000121
1000000000163
*stopped*
