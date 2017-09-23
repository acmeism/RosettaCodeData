(defpackage #:mandelbrot
  (:use #:cl))

(in-package #:mandelbrot)

(deftype pixel () '(unsigned-byte 8))
(deftype image () '(array pixel))

(defun write-pgm (image filespec)
  (declare (image image))
  (with-open-file (s filespec :direction :output :element-type 'pixel :if-exists :supersede)
    (let* ((width  (array-dimension image 1))
           (height (array-dimension image 0))
           (header (format nil "P5~A~D ~D~A255~A" #\Newline width height #\Newline #\Newline)))
      (loop for c across header
            do (write-byte (char-code c) s))
      (dotimes (row height)
        (dotimes (col width)
          (write-byte (aref image row col) s))))))

(defparameter *x-max* 800)
(defparameter *y-max* 800)
(defparameter *cx-min* -2.5)
(defparameter *cx-max* 1.5)
(defparameter *cy-min* -2.0)
(defparameter *cy-max* 2.0)
(defparameter *escape-radius* 2)
(defparameter *iteration-max* 40)

(defun mandelbrot (filespec)
  (let ((pixel-width  (/ (- *cx-max* *cx-min*) *x-max*))
        (pixel-height (/ (- *cy-max* *cy-min*) *y-max*))
        (image (make-array (list *y-max* *x-max*) :element-type 'pixel :initial-element 0)))
    (loop for y from 0 below *y-max*
          for cy from *cy-min* by pixel-height
          do (loop for x from 0 below *x-max*
                   for cx from *cx-min* by pixel-width
                   for iteration = (loop with c = (complex cx cy)
                                         for iteration from 0 below *iteration-max*
                                         for z = c then (+ (* z z) c)
                                         while (< (abs z) *escape-radius*)
                                         finally (return iteration))
                   for pixel = (round (* 255 (/ (- *iteration-max* iteration) *iteration-max*)))
                   do (setf (aref image y x) pixel)))
    (write-pgm image filespec)))
