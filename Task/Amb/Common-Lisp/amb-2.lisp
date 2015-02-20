(defparameter *amb-ops* nil)
(defparameter *amb-hist* nil)

(setf *random-state* (make-random-state t))
(defun shuffle (items)
  (loop for i from 0 with r = items with l = (length r) while (< i l) do
	(rotatef (elt r i) (elt r (+ i (random (- l i)))))
	finally (return r)))

;;; (assert '(mess in, mess out))
(defmacro amb (a &rest rest)
  (let ((f (first rest))
	(rest (rest rest)))
    (if (not f)
      `(let ((items (shuffle ,a)))
	   (let ((y (car (last *amb-hist*)))
		 (o (car (last *amb-ops*))))
	     (loop for x in items do
		   (if (or (not *amb-ops*)
			   (funcall o y x))
			   (return (append *amb-hist* (list x))))
	   (elt items (random (length items))))))

      `(let ((items (shuffle ,a)))
	   (let ((y (car (last *amb-hist*)))
		 (o (car (last *amb-ops*))))
	     (loop for x in items do
		   (if (or (not *amb-ops*)
			   (funcall o y x))
		     (let ((*amb-hist* (append *amb-hist* (list x)))
			   (*amb-ops*  (append *amb-ops* (list ,f))))
		       (let ((r ,@rest))
			 (if r (return r)))))))))))

;; test cases
(defun joins (a b)
  (char= (char a (1- (length a))) (char b 0)))

(defun w34()
  (amb '("walked" "treaded" "grows") #'joins
       (amb '("slowly" "quickly"))))

(print
  (amb '("the" "that" "a") #'joins
       (amb '("frog" "elephant" "thing") #'joins
	    (w34))))

(print (amb '(1 2 5) #'<
	    (amb '(2 3 4) #'=
		 (amb '(3 4 5))))) ; 1 4 4, 2 3 3, etc
