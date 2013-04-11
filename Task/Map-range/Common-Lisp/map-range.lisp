(defun map-range (a1 a2 b1 b2 s)
  (+ b1
     (/ (* (- s a1)
	   (- b2 b1))
	(- a2 a1))))

(loop
   for i from 0 to 10
   do (format t "~F maps to ~F~C" i
	      (map-range 0 10 -1 0 i)
	      #\Newline))
