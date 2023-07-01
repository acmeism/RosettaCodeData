(defpackage #:chaos
  (:use #:cl
        #:opticl))

(in-package #:chaos)

(defparameter *image-size* 600)
(defparameter *margin* 50)
(defparameter *edge-size* (- *image-size* *margin* *margin*))
(defparameter *iterations* 1000000)

(defun chaos ()
  (let ((image (make-8-bit-rgb-image *image-size* *image-size* :initial-element 255))
        (a (list (- *image-size* *margin*) *margin*))
        (b (list (- *image-size* *margin*) (- *image-size* *margin*)))
        (c (list (- *image-size* *margin* (round (* (tan (/ pi 3)) *edge-size*) 2))
                 (round *image-size* 2)))
        (point (list (+ (random *edge-size*) *margin*)
                     (+ (random *edge-size*) *margin*))))
    (dotimes (i *iterations*)
      (let ((ref (ecase (random 3)
                   (0 a)
                   (1 b)
                   (2 c))))
        (setf point (list (round (+ (first  point) (first  ref)) 2)
                          (round (+ (second point) (second ref)) 2))))
      (setf (pixel image (first point) (second point))
            (values 255 0 0)))
    (write-png-file "chaos.png" image)))
