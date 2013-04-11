(setf *random-state* (make-random-state t))

(defun 2d-array (w h)
  (make-array (list h w) :initial-element 0))

(defmacro or-and (v a b c)
  `(if (or ,a (and ,b (= 1 ,c))) 0 ,v))

(defun make-maze (w h)
  (let ((vis (2d-array w h))
	(ver (2d-array w h))
	(hor (2d-array w h)))
    (labels
      ((walk (y x)
	     (setf (aref vis y x) 1)
	     (loop
	       (let (x2 y2)
		 (loop for (dx dy) in '((-1 0) (1 0) (0 -1) (0 1))
		       with cnt = 0 do
		       (let ((xx (+ x dx))
			     (yy (+ y dy)))
			 (if (and (array-in-bounds-p vis yy xx)
				  (zerop (aref vis yy xx))
				  (zerop (random (incf cnt))))
			   (setf x2 xx y2 yy))))
		 (if (not x2) (return-from walk))
		 (if (= x x2)
		   (setf (aref hor (min y y2) x) 1)
		   (setf (aref ver y (min x x2)) 1))
		 (walk y2 x2))))

      (show ()
	     (let ((g " │││─┘┐┤─└┌├─┴┬┼"))
	       (loop for i from 0 to h do
		     (loop for j from 0 to w do
			   (format t "~c~a"
			     (char g
			       (+ (or-and 1 (= i 0) (> j 0) (aref ver (1- i) (1- j)))
				  (or-and 2 (= i h) (> j 0) (aref ver i      (1- j)))
				  (or-and 4 (= j 0) (> i 0) (aref hor (1- i) (1- j)))
				  (or-and 8 (= j w) (> i 0) (aref hor (1- i) j    ))))
			     (if (and (< j w)
				      (or (= i 0)
					  (= 0 (aref hor (1- i) j))))
			       "───" "   ")))
		     (terpri)
		     (when (< i h)
		       (loop for j from 0 below w do
			     (format t (if (or (= j 0)
					       (= 0 (aref ver i (1- j))))
					 "│   " "    ")))
		       (format t "│~%"))))))

      (walk (random h) (random w))
      (show))))

(make-maze 20 20)
