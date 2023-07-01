;;; memoize
(defmacro mm-set (p v) `(if ,p ,p (setf ,p ,v)))

(defun knapsack (max-weight items)
  (let ((cache (make-array (list (1+ max-weight) (1+ (length items)))
			   :initial-element nil)))

    (labels ((knapsack1 (spc items)
	(if (not items) (return-from knapsack1 (list 0 0 '())))
	(mm-set (aref cache spc (length items))
		(let* ((i (first items))
		       (w (second i))
		       (v (third i))
		       (x (knapsack1 spc (cdr items))))
		  (if (> w spc) x
		    (let* ((y (knapsack1 (- spc w) (cdr items)))
			   (v (+ v (first y))))
		      (if (< v (first x)) x
			(list v (+ w (second y)) (cons i (third y))))))))))

      (knapsack1 max-weight items))))

(print
  (knapsack 400
	    '((map 9 150) (compass 13 35) (water 153 200) (sandwich 50 160)
	      (glucose 15 60) (tin 68 45)(banana 27 60) (apple 39 40)
	      (cheese 23 30) (beer 52 10) (cream 11 70) (camera 32 30)
	      (T-shirt 24 15) (trousers 48 10) (umbrella 73 40)
	      (trousers 42 70) (overclothes 43 75) (notecase 22 80)
	      (glasses 7 20) (towel 18 12) (socks 4 50) (book 30 10))))
