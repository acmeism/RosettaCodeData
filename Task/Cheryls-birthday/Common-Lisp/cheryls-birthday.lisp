;; Author: Amir Teymuri, Saturday 20.10.2018

(defparameter *possible-dates*
  '((15 . may) (16 . may) (19 . may)
    (17 . june) (18 . june)
    (14 . july) (16 . july)
    (14 . august) (15 . august) (17 . august)))

(defun unique-date-parts (possible-dates &key (alist-look-at #'car) (alist-r-assoc #'assoc))
  (let* ((date-parts (mapcar alist-look-at possible-dates))	
	 (unique-date-parts (remove-if #'(lambda (part) (> (count part date-parts) 1)) date-parts)))
    (mapcar #'(lambda (part) (funcall alist-r-assoc part possible-dates))
    	    unique-date-parts)))

(defun person (person possible-dates)
  "Who's turn is it to think?"
  (case person
    ('albert (unique-date-parts possible-dates :alist-look-at #'cdr :alist-r-assoc #'rassoc))
    ('bernard (unique-date-parts possible-dates :alist-look-at #'car :alist-r-assoc #'assoc))))

(defun cheryls-birthday (possible-dates)
  (person 'albert			
	  (person 'bernard		
		  (set-difference
		   possible-dates
		   (person 'bernard possible-dates)
		   :key #'cdr))))

(cheryls-birthday *possible-dates*) ;; => ((16 . JULY))
