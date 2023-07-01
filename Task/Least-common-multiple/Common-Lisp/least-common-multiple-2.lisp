CL-USER> (defun my-lcm (&rest args)
	   (reduce (lambda (m n)
		     (cond ((or (= m 0) (= n 0)) 0)
			   (t (abs (/ (* m n) (gcd m n))))))
		   args :initial-value 1))
MY-LCM
CL-USER> (my-lcm 12 18)
36
CL-USER> (my-lcm 12 18 22)
396
