;;; Tail-recursive version
(defun factor (n &optional (acc '()))
  (when (> n 1) (loop with max-d = (isqrt n)
		   for d = 2 then (if (evenp d) (1+ d) (+ d 2)) do
		     (cond ((> d max-d) (return (cons (list n 1) acc)))
			   ((zerop (rem n d))
			    (return (factor (truncate n d) (if (eq d (caar acc))
							       (cons
								(list (caar acc) (1+ (cadar acc)))
								(cdr acc))
							       (cons (list d 1) acc)))))))))
