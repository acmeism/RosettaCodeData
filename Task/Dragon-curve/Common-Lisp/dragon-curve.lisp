(defpackage #:dragon
  (:use #:clim-lisp #:clim)
  (:export #:dragon #:dragon-part))
(in-package #:dragon)

(defun dragon-part (depth bend-direction)
  (if (zerop depth)
      (draw-line* *standard-output* 0 0 1 0)
      (with-scaling (t (/ (sqrt 2)))
        (with-rotation (t (* pi -1/4 bend-direction))
          (dragon-part (1- depth) 1)
          (with-translation (t 1 0)
            (with-rotation (t (* pi 1/2 bend-direction))
              (dragon-part (1- depth) -1)))))))

(defun dragon (&optional (depth 7) (size 100))
  (with-room-for-graphics ()
    (with-scaling (t size)
      (dragon-part depth 1))))
