(let ((a (read *standard-input*))
      (b (read *standard-input*)))
    (cond
      ((not (numberp a)) (format t "~A is not a number." a))
      ((not (numberp b)) (format t "~A is not a number." b))
      ((< a b) (format t "~A is less than ~A." a b))
      ((> a b) (format t "~A is greater than ~A." a b))
      ((= a b) (format t "~A is equal to ~A." a b))
      (t (format t "Cannot determine relevance between ~A and ~B!" a b)))))
