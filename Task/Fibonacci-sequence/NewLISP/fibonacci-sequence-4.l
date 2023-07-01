;;;	Global variable (bigints); can be isolated in a namespace if need be
(setq stack '(0L 1L))
;
;;;	If the stack is too short, complete it; then read from it
;;;	Adding at the end of a list is optimized in NewLisp
(define (fib n)
	(while (<= (length stack) n)
		(push (+ (stack -1) (stack -2)) stack -1))
	(stack n))
;
;;; Test (~ 7+ s on my mediocre laptop)
;(println (time (fib 50000)))
;;;	or
(println (length (fib 50000)))
;;;	outputs 10450 (digits)
