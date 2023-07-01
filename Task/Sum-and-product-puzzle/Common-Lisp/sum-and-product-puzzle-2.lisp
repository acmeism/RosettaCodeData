;;; Algorithm of Rosetta code:

;;; All possible pairs
(defparameter *all-possible-pairs*
  (loop for i from 2 upto 100
     append (loop for j from (1+ i) upto 100
	       if (<= (+ i j) 100)
	       collect (list i j))))

(defun oncep (item list)
  (eql 1 (count item list)))

;;; Terminology
(defun sum-decomp (n)
  (loop for x from 2 below (/ n 2)
     for y = (- n x)
     collect (list x y)))

(defun prod-decomp (n)
  (loop for x from 2 below (sqrt n)
     for y = (/ n x)
     if (and (>= 100 (+ x y)) (zerop (rem n x)))
     collect (list x y)))

;;; For every possible sum decomposition of the number X+Y, the product has in turn more than one product decomposition:
(defun fact-1 (n)
  "n = x + y"
  (flet ((premise (pair)
	       (> (list-length (prod-decomp (apply #'* pair))) 1)))
	(every #'premise (sum-decomp n))))

;;; The number X*Y has only one product decomposition for which fact 1 is true:
(defun fact-2 (n)
  "n = x * y"
  (oncep t (mapcar (lambda (pair) (fact-1 (apply #'+ pair))) (prod-decomp n))))

;;; The number X+Y has only one sum decomposition for which fact 2 is true:
(defun fact-3 (n)
  "n = x + y"
  (oncep t (mapcar (lambda (pair) (fact-2 (apply #'* pair))) (sum-decomp n))))

(defun find-xy (all-possible-pairs)
  (remove-if-not
   #'(lambda (p) (fact-3 (apply #'+ p)))
   (remove-if-not
    #'(lambda (p) (fact-2 (apply #'* p)))
    (remove-if-not
     #'(lambda (p) (fact-1 (apply #'+ p)))
     all-possible-pairs))))

(find-xy *all-possible-pairs*) ;; => ((4 13))
