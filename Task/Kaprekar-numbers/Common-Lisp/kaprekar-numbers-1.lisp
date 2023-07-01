;; make an infinite list whose accumulated sums give all
;; numbers n where n mod (base - 1) == n^2 mod (base - 1)
(defun res-list (base)
    (let* ((b (- base 1))
           (l (remove-if-not
		    (lambda (x) (= (rem x b) (rem (* x x) b)))
		    (loop for x from 0 below b collect x)))
	   (ret (append l (list b)))
	   (cycle (mapcar #'- (cdr ret) ret)))
	(setf (cdr (last cycle)) cycle)))

(defun kaprekar-p (n &optional (base 10))
   "tests if n is kaprekar in base; if so, return left and right half"
   (let ((nn (* n n)) (tens 1))
	; Find a start value for base power.  nn/tens + (nn mod tens) == n
	; can't be sastified if tens <= n: nn/tens = n * n / tens > n
	(loop while (< tens n) do
	      (setf tens (* tens base)))
	(if (= tens n)  ; n a power of base, can't be a solution except 1
	    (if (= n 1) (values T 0 1))
	    (loop
	       (let ((left (truncate nn tens)) (right (mod nn tens)))
		    (cond ((>= right n) (return nil))
			  ((= n (+ left right)) (return (values T left right))))
		    (setf tens (* base tens)))))))

(defun ktest (top &optional (base 10))
   (format t "   #    Value     Left    Right       Squared (base ~D)~%" base)
   (let ((fmt (format nil "~~4D ~~~D,8R ~~~D,8R ~~~D,8R ~~~D,13R~~%"
                      base base base base base))
	 (res (res-list base))
	 (n 0))
   	 (loop with cnt = 0 while (<= n top) do
	 	(setf n (+ n (car res)))
		(setf res (cdr res))
	 	(multiple-value-bind (k l r) (kaprekar-p n base)
		   (when k (format t fmt (incf cnt) n l r (* n n)))))))

(ktest 1000000)
(terpri)
(ktest 1000000 17)
