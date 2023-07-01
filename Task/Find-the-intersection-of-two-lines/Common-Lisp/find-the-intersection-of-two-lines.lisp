;; Point is [x y] tuple
(defun point-of-intersection (x1 y1 x2 y2 x3 y3 x4 y4)
"Find the point of intersection of the lines defined by the points (x1 y1) (x2 y2) and (x3 y3) (x4 y4)"
  (let* ((dx1 (- x2 x1))
         (dx2 (- x4 x3))
         (dy1 (- y2 y1))
         (dy2 (- y4 y3))
         (den (- (* dy1 dx2) (* dy2 dx1))) )
    (unless (zerop den)
  	(list (/ (+ (* (- y3 y1) dx1 dx2) (* x1 dy1 dx2) (* -1 x3 dy2 dx1)) den)	  	
       	      (/ (+ (* (+ x3 x1) dy1 dy2) (* -1 y1 dx1 dy2) (* y3 dx2 dy1)) den) ))))
