;;; Calculate all x's and their possible y's.
(defparameter *x-possibleys*
  (loop for x from 2 to 49
     collect (cons x (loop for y from (- 100 x) downto (1+ x)
			collect y)))
  "For every x there are certain y's, with respect to the rules of the puzzle")

(defun xys-operation (op x-possibleys)
  "returns an alist of ((x possible-y) . (op x possible-y))"
  (let ((x (car x-possibleys))
	(ys (cdr x-possibleys)))
    (mapcar #'(lambda (y) (cons (list x y) (funcall op x y))) ys)))

(defun sp-numbers (op x-possibleys)
  "generates all possible sums or products of the puzzle"
  (loop for xys in x-possibleys
       append (xys-operation op xys)))

(defun group-sp (sp-numbers)
  "sp: Sum or Product"
  (loop for sp-number in (remove-duplicates sp-numbers :key #'cdr)
     collect (cons (cdr sp-number)
		   (mapcar #'car
			   (remove-if-not
			    #'(lambda (sp) (= sp (cdr sp-number)))
			    sp-numbers
			    :key #'cdr)))))

(defun statement-1a (sum-groups)
  "remove all sums with a single possible xy"
  (remove-if
   #'(lambda (xys) (= (list-length xys) 1))
   sum-groups
   :key #'cdr))

(defun statement-1b (x-possibleys)
  "S says: P does not know X and Y."
  (let ((multi-xy-sums (statement-1a (group-sp (sp-numbers #'+ x-possibleys))))
	(products (group-sp (sp-numbers #'* x-possibleys))))
    (flet ((sum-has-xy-which-leads-to-unique-prod (sum-xys)
	     ;; is there any product with a single possible xy?
	     (some #'(lambda (prod-xys) (= (list-length (cdr prod-xys)) 1))
		   ;; all possible xys of the sum's (* x ys)
		   (mapcar #'(lambda (xy) (assoc (apply #'* xy) products))
			   (cdr sum-xys)))))
      ;; remove sums with even one xy which leads to a unique product
      (remove-if #'sum-has-xy-which-leads-to-unique-prod multi-xy-sums))))

(defun remaining-products (remaining-sums-xys)
  "P's number is one of these"
  (loop for sum-xys in remaining-sums-xys
     append (loop for xy in (cdr sum-xys)
	       collect (apply #'* xy))))

(defun statement-2 (remaining-sums-xys)
  "P says: Now I know X and Y."
  (let ((remaining-products (remaining-products remaining-sums-xys)))
    (mapcar #'(lambda (a-sum-unit)
		(cons (car a-sum-unit)
		      (mapcar #'(lambda (xy)
				  (list (count (apply #'* xy) remaining-products)
					xy))
			      (cdr a-sum-unit))))
	    remaining-sums-xys)))

(defun statement-3 (remaining-sums-with-their-products-occurrences-info)
  "S says: Now I also know X and Y."
  (remove-if
   #'(lambda (sum-xys)
       ;; remove those sums which have more than 1 product, that
       ;; appear only once amongst all remaining products
       (> (count 1 sum-xys :key #'car) 1))
   remaining-sums-with-their-products-occurrences-info
   :key #'cdr))

(defun solution (survivor-sum-and-its-xys)
  "Now we know X and Y too :-D"
  (let* ((sum (caar survivor-sum-and-its-xys))
	 (xys (cdar survivor-sum-and-its-xys))
	 (xy (second (find 1 xys :key #'car))))
    (pairlis '(x y sum product)
	     (list (first xy) (second xy) sum (apply #'* xy)))))


(solution
 (statement-3
  (statement-2
   (statement-1b *x-possibleys*)))) ;; => ((PRODUCT . 52) (SUM . 17) (Y . 13) (X . 4))
