(define (bump-value)
	(when (> value 1)
	(set! count (1+ count))
	(set! value (if (even? value) (/ value 2) (1+ (* 3 value))))))
	
(define (env-show name envs )
(write name)
(for ((env envs)) (write (format "%4a" (eval name env))))
(writeln))

(define (task (envnum 12))
(define envs (for/list ((i envnum)) (environment-new `((value ,(1+ i)) (count 0)))))
(env-show 'value envs)
(while
	(any  (curry  (lambda ( n env) (!= 1 (eval n env))) 'value) envs)
	(for/list ((env envs)) (eval '(bump-value) env))
	(env-show 'value envs))
(env-show 'count envs))
