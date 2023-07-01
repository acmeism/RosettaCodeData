(defpackage #:barnsley-fern
  (:use #:cl
        #:opticl))

(in-package #:barnsley-fern)

(defparameter *width* 800)
(defparameter *height* 800)
(defparameter *factor* (/ *height* 13))
(defparameter *x-offset* (/ *width* 2))
(defparameter *y-offset* (/ *height* 10))

(defun f1 (x y)
  (declare (ignore x))
  (values 0 (* 0.16 y)))

(defun f2 (x y)
  (values (+ (*  0.85 x) (* 0.04 y))
          (+ (* -0.04 x) (* 0.85 y) 1.6)))

(defun f3 (x y)
  (values (+ (* 0.2  x) (* -0.26 y))
          (+ (* 0.23 x) (*  0.22 y) 1.6)))

(defun f4 (x y)
  (values (+ (* -0.15 x) (* 0.28 y))
          (+ (*  0.26 x) (* 0.24 y) 0.44)))

(defun choose-transform ()
  (let ((r (random 1.0)))
    (cond ((< r 0.01) #'f1)
          ((< r 0.86) #'f2)
          ((< r 0.93) #'f3)
          (t          #'f4))))

(defun set-pixel (image x y)
  (let ((%x (round (+ (* *factor* x) *x-offset*)))
        (%y (round (- *height* (* *factor* y) *y-offset*))))
    (setf (pixel image %y %x) (values 0 255 0))))

(defun fern (filespec &optional (iterations 10000000))
  (let ((image (make-8-bit-rgb-image *height* *width* :initial-element 0))
        (x 0)
        (y 0))
    (dotimes (i iterations)
      (set-pixel image x y)
      (multiple-value-setq (x y) (funcall (choose-transform) x y)))
    (write-png-file filespec image)))
