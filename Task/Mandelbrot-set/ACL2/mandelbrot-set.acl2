(defun abs-sq (z)
   (+ (expt (realpart z) 2)
      (expt (imagpart z) 2)))

(defun round-decimal (x places)
   (/ (floor (* x (expt 10 places)) 1)
      (expt 10 places)))

(defun round-complex (z places)
   (complex (round-decimal (realpart z) places)
            (round-decimal (imagpart z) places)))

(defun mandel-point-r (z c limit)
   (declare (xargs :measure (nfix limit)))
   (cond ((zp limit) 0)
         ((> (abs-sq z) 4) limit)
         (t (mandel-point-r (+ (round-complex (* z z) 15) c)
                            c
                            (1- limit)))))

(defun mandel-point (z iters)
   (- 5 (floor (mandel-point-r z z iters) (/ iters 5))))

(defun draw-mandel-row (im re cols width iters)
   (declare (xargs :measure (nfix cols)))
   (if (zp cols)
       nil
       (prog2$ (cw (coerce
                    (list
                     (case (mandel-point (complex re im)
                                         iters)
                           (5 #\#)
                           (4 #\*)
                           (3 #\.)
                           (2 #\.)
                           (otherwise #\Space))) 'string))
               (draw-mandel-row im
                                (+ re (/ (/ width 3)))
                                (1- cols)
                                width iters))))

(defun draw-mandel (im rows width height iters)
   (if (zp rows)
       nil
       (progn$ (draw-mandel-row im -2 width width iters)
               (cw "~%")
               (draw-mandel (- im (/ (/ height 2)))
                            (1- rows)
                            width
                            height
                            iters))))

(defun draw-mandelbrot (width iters)
   (let ((height (floor (* 1000 width) 3333)))
        (draw-mandel 1 height width height iters)))
