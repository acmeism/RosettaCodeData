(define (step-up) (while (not (step)) (step-up)))
;; checking this is tail-recusive :
step-up
   → (#λ null (#while (#not (step)) (#lambda-tail-call)))

;; Experimentation (not part of the task)
;; How much step calls to climb  1000 stairs ?
;; success is the robot success probability
(define (step)
 (set! STEPS (1+ STEPS)) ;; count
 (< (random) SUCCESS)) ;; ->#t or #f

(define (climb stairs)
	(when (> stairs 0)  (step-up) (climb (1- stairs))))
	
(define (task  (stairs 1000))
	(for ((success (in-range 1 0 -5/100)))
	(set! SUCCESS success)
	(set! STEPS 0)
	(climb stairs)
	(writeln 'stairs stairs 'probability success 'steps STEPS)))
