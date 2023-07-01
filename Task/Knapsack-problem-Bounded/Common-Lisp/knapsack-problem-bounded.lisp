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
	     (loop for cnt from 1 to (fourth i) do
		   (let ((w (* cnt w)) (v (* cnt v)))
		     (if (>= spc w)
		       (let ((y (knapsack1 (- spc w) (cdr items))))
			 (if (> (+ (first y) v) (first x))
			   (setf x (list (+ (first  y) v)
					 (+ (second y) w)
					 (cons (list (first i) cnt) (third y)))))))))
	     x))))

      (knapsack1 max-weight items))))

(print
  (knapsack 400
	    '((map 9 150 1) (compass 13 35 1) (water 153 200 2) (sandwich 50 60 2)
              (glucose 15 60 2) (tin 68 45 3) (banana 27 60 3) (apple 39 40 3)
	      (cheese 23 30 1) (beer 52 10 3) (cream 11 70 1) (camera 32 30 1)
	      (T-shirt 24 15 2) (trousers 48 10 2) (umbrella 73 40 1)
	      (trousers 42 70 1) (overclothes 43 75 1) (notecase 22 80 1)
	      (glasses 7 20 1) (towel 18 12 2) (socks 4 50 1) (book 30 10 2))))
