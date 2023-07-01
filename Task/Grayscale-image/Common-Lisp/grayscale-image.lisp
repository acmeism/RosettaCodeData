(in-package #:rgb-pixel-buffer)

(defun rgb-to-gray-image (rgb-image)
  (flet ((rgb-to-gray (rgb-value)
	   (round (+ (* 0.2126 (rgb-pixel-red rgb-value))
		     (* 0.7152 (rgb-pixel-green rgb-value))
		     (* 0.0722 (rgb-pixel-blue rgb-value))))))
    (let ((gray-image (make-array (array-dimensions rgb-image) :element-type '(unsigned-byte 8))))
      (dotimes (i (array-total-size rgb-image))
	(setf (row-major-aref gray-image i) (rgb-to-gray (row-major-aref rgb-image i))))
      gray-image)))

(export 'rgb-to-gray-image)


(defun grayscale-image-to-pgm-file (image file-name &optional (max-value 255))
  (with-open-file (p file-name :direction :output
		     :if-exists :supersede)
    (format p "P2 ~&~A ~A ~&~A" (array-dimension image 1) (array-dimension image 0) max-value)
    (dotimes (i (array-total-size image))
      (print (row-major-aref image i) p))))

(export 'grayscale-image-to-pgm-file)
