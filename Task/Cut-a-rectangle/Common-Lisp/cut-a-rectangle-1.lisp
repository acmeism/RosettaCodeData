(defun cut-it (w h &optional (recur t))
  (if (oddp (* w h)) (return-from cut-it 0))
  (if (oddp h) (rotatef w h))
  (if (= w 1) (return-from cut-it h))

  (let ((cnt 0)
	(m (make-array (list (1+ h) (1+ w))
		       :element-type 'bit
		       :initial-element 0))
	(cy (truncate h 2))
	(cx (truncate w 2)))

    (setf (aref m cy cx) 1)
    (if (oddp w) (setf (aref m cy (1+ cx)) 1))

    (labels
      ((walk (y x turned)
	     (when (or (= y 0) (= y h) (= x 0) (= x w))
	       (incf cnt (if turned 2 1))
	       (return-from walk))

	     (setf (aref m y x) 1)
	     (setf (aref m (- h y) (- w x)) 1)
	     (loop for i from 0
		   for (dy dx) in '((0 -1) (-1 0) (0 1) (1 0))
		   while (or turned (< i 2)) do
		   (let ((y2 (+ y dy))
			 (x2 (+ x dx)))
		     (when (zerop (aref m y2 x2))
		       (walk y2 x2 (or turned (> i 0))))))
	     (setf (aref m (- h y) (- w x)) 0)
	     (setf (aref m y x) 0)))

      (walk cy (1- cx) nil)
      (cond ((= h w) (incf cnt cnt))
	    ((oddp w) (walk (1- cy) cx t))
	    (recur (incf cnt (cut-it h w nil))))
    cnt)))

(loop for w from 1 to 9 do
      (loop for h from 1 to w do
	    (if (evenp (* w h))
	      (format t "~d x ~d: ~d~%" w h (cut-it w h)))))
