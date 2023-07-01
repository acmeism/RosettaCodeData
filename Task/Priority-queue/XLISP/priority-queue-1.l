(define-class priority-queue
	(instance-variables queue lowest-priority most-urgent) )

(define-method (priority-queue 'initialize limit)
	(defun setup (x)
		(vector-set! queue x nil)
		(if (< x limit)
			(setup (+ x 1)) ) )
	(setq lowest-priority limit)
	(setq most-urgent limit)
	(setq queue (make-vector (+ limit 1)))
	(setup 0)
	self )

(define-method (priority-queue 'push item priority)
	(if (and (integerp priority) (>= priority 0) (<= priority lowest-priority))
		(progn
			(setq most-urgent (min priority most-urgent))
			(vector-set! queue priority (nconc (vector-ref queue priority) (cons item nil))) ) ) )

(define-method (priority-queue 'pop)
	(defun find-next (q)
		(if (or (= q lowest-priority) (not (null (vector-ref queue q))))
			q
			(find-next (+ q 1)) ) )
	(define item (car (vector-ref queue most-urgent)))
	(vector-set! queue most-urgent (cdr (vector-ref queue most-urgent)))
	(setq most-urgent (find-next most-urgent))
	item )

(define-method (priority-queue 'peek)
	(car (vector-ref queue most-urgent)) )

(define-method (priority-queue 'emptyp)
	(and (= most-urgent lowest-priority) (null (vector-ref queue most-urgent))) )
