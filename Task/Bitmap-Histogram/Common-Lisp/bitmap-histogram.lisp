(defpackage #:histogram
  (:use #:cl
        #:opticl))

(in-package #:histogram)

(defun color->gray-image (image)
  (check-type image 8-bit-rgb-image)
  (let ((gray-image (with-image-bounds (height width) image
                      (make-8-bit-gray-image height width :initial-element 0))))
    (do-pixels (i j) image
      (multiple-value-bind (r g b) (pixel image i j)
        (let ((gray (+ (* 0.2126 r) (* 0.7152 g) (* 0.0722 b))))
          (setf (pixel gray-image i j) (round gray)))))
    gray-image))

(defun make-histogram (image)
  (check-type image 8-bit-gray-image)
  (let ((histogram (make-array 256 :element-type 'fixnum :initial-element 0)))
    (do-pixels (i j) image
      (incf (aref histogram (pixel image i j))))
    histogram))

(defun find-median (histogram)
  (loop with num-pixels = (loop for count across histogram sum count)
        with half = (/ num-pixels 2)
        for count across histogram
        for i from 0
        sum count into acc
        when (>= acc half)
          return i))

(defun gray->black&white-image (image)
  (check-type image 8-bit-gray-image)
  (let* ((histogram (make-histogram image))
         (median (find-median histogram))
         (bw-image (with-image-bounds (height width) image
                     (make-1-bit-gray-image height width :initial-element 0))))
    (do-pixels (i j) image
      (setf (pixel bw-image i j) (if (<= (pixel image i j) median) 1 0)))
    bw-image))

(defun main ()
  (let* ((image (read-jpeg-file "lenna.jpg"))
         (bw-image (gray->black&white-image (color->gray-image image))))
    (write-pbm-file "lenna-bw.pbm" bw-image)))
