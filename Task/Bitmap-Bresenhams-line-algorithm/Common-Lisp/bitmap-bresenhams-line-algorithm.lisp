(defun draw-line (buffer x1 y1 x2 y2 pixel)
  (declare (type rgb-pixel-buffer buffer))
  (declare (type integer x1 y1 x2 y2))
  (declare (type rgb-pixel pixel))
  (let* ((dist-x (abs (- x1 x2)))
   (dist-y (abs (- y1 y2)))
   (steep (> dist-y dist-x)))
    (when steep
      (psetf x1 y1 y1 x1
       x2 y2 y2 x2))
    (when (> x1 x2)
      (psetf x1 x2 x2 x1
       y1 y2 y2 y1))
    (let* ((delta-x (- x2 x1))
     (delta-y (abs (- y1 y2)))
     (error (floor delta-x 2))
     (y-step (if (< y1 y2) 1 -1))
     (y y1))
      (loop
   :for x :upfrom x1 :to x2
   :do (progn (if steep
      (setf (rgb-pixel buffer x y) pixel)
      (setf (rgb-pixel buffer y x) pixel))
        (setf error (- error delta-y))
        (when (< error 0)
          (incf y y-step)
          (incf error delta-x)))))
    buffer))
