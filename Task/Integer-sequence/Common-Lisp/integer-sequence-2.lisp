(defun pp (x) (pp (1+ (print x))))
(funcall (compile 'pp) 1) ; it's less likely interpreted mode will eliminate tails
