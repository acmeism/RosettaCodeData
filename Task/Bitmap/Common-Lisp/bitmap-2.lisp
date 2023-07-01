(in-package #:rgb-pixel-buffer)

(deftype rgb-pixel-component ()
  '(unsigned-byte 8))

(deftype rgb-pixel ()
  '(unsigned-byte 24))

(deftype rgb-pixel-buffer (&optional (width '*) (height '*))
  `(array rgb-pixel (,width ,height)))

(defconstant +black+ 0)
(defconstant +white+ #xFFFFFF)
(defconstant +red+ #xFF0000)
(defconstant +green+ #x00FF00)
(defconstant +blue+ #x0000FF)

(defun make-rgb-pixel (r g b)
  (declare (type rgb-pixel-component r g b))
  (logior (ash r 16) (ash g 8) b))

(defun rgb-pixel-red (rgb)
  (declare (type rgb-pixel rgb))
  (logand (ash rgb -16) #xFF))

(defun rgb-pixel-green (rgb)
  (declare (type rgb-pixel rgb))
  (logand (ash rgb -8) #xFF))

(defun rgb-pixel-blue (rgb)
  (declare (type rgb-pixel rgb))
  (logand rgb #xFF))

(defun make-rgb-pixel-buffer (width height &optional (initial-element +black+))
  (declare (type (integer 1) width height))
  (declare (type rgb-pixel initial-element))
  (make-array (list width height)
    :element-type 'rgb-pixel
    :initial-element initial-element))

(defun rgb-pixel-buffer-width (buffer)
  (first (array-dimensions buffer)))

(defun rgb-pixel-buffer-height (buffer)
  (second (array-dimensions buffer)))

(defun rgb-pixel (buffer x y)
  (declare (type rgb-pixel-buffer buffer))
  (declare (type (integer 0) x y))
  (aref buffer x y))

(defun (setf rgb-pixel) (value buffer x y)
  (declare (type rgb-pixel-buffer buffer))
  (declare (type rgb-pixel value))
  (declare (type (integer 0) x y))
  (setf (aref buffer x y) value))

(defun fill-rgb-pixel-buffer (buffer pixel)
  (declare (type rgb-pixel-buffer buffer))
  (declare (type rgb-pixel pixel))
  (let* ((dimensions (array-dimensions buffer))
	 (width (first dimensions))
	 (height (second dimensions)))
    (loop
       :for y :of-type fixnum :upfrom 0 :below height
       :do (loop
	      :for x :of-type fixnum :upfrom 0 :below width
	      :do (setf (rgb-pixel buffer x y) pixel)))
    buffer))
