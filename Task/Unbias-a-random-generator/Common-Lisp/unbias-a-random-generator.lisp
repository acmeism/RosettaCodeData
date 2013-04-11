(defun biased (n) (if (zerop (random n)) 0 1))

(defun unbiased (n)
    (loop with x do
      (if (/= (setf x (biased n)) (biased n))
	    (return x))))

(loop for n from 3 to 6 do
      (let ((u (loop repeat 10000 collect (unbiased n)))
	    (b (loop repeat 10000 collect (biased n))))
	(format t "~a: unbiased ~d biased ~d~%" n (count 0 u) (count 0 b))))
