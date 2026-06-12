#!/usr/bin/env newlisp

(context 'SM)

(define (SM:meaning-of-life) 42)

(define (main)
	(println (format "Main: The meaning of life is %d" (meaning-of-life)))
	(exit))

(if (find "scriptedmain" (main-args 1)) (main))

(context MAIN)
