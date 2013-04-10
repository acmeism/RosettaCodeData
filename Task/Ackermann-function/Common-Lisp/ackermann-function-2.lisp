(defun ackermann (m n)
  (case m ((0) (1+ n))
    ((1) (+ 2 n))
    ((2) (+ n n 3))
    ((3) (- (expt 2 (+ 3 n)) 3))
    (otherwise (ackermann (1- m) (if (zerop n) 1 (ackermann m (1- n)))))))

(loop for m from 0 to 4 do
      (loop for n from (- 5 m) to (- 6 m) do
	    (format t "A(~d, ~d) = ~d~%" m n (ackermann m n))))
