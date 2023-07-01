;;; equally doable with a list
(flet ((seq (i) (make-array 1 :element-type 'integer
			      :initial-element i
			      :fill-pointer 1
			      :adjustable t)))
  (let ((rr (seq 1)) (ss (seq 2)))
    (labels ((extend-r ()
		       (let* ((l (1- (length rr)))
			      (r (+ (aref rr l) (aref ss l)))
			      (s (elt ss (1- (length ss)))))
			 (vector-push-extend r rr)
			 (loop while (<= s r) do
			       (if (/= (incf s) r)
				 (vector-push-extend s ss))))))
      (defun seq-r (n)
	(loop while (> n (length rr)) do (extend-r))
	(elt rr (1- n)))

      (defun seq-s (n)
	(loop while (> n (length ss)) do (extend-r))
	(elt ss (1- n))))))

(defun take (f n)
  (loop for x from 1 to n collect (funcall f x)))

(format t "First of R: ~a~%" (take #'seq-r 10))

(mapl (lambda (l) (if (and (cdr l)
			   (/= (1+ (car l)) (cadr l)))
		    (error "not in sequence")))
      (sort (append (take #'seq-r 40)
		    (take #'seq-s 960))
	    #'<))
(princ "Ok")
