(load "rgb-pixel-buffer")
(load "ppm-file-io")

(defpackage #:convolve
  (:use #:common-lisp #:rgb-pixel-buffer #:ppm-file-io))

(in-package #:convolve)
(defconstant +row-offsets+ '(-1 -1 -1 0 0 0 1 1 1))
(defconstant +col-offsets+ '(-1 0 1 -1 0 1 -1 0 1))
(defstruct cnv-record descr width kernel divisor offset)
(defparameter *cnv-lib* (make-hash-table))
(setf (gethash 'emboss *cnv-lib*)
      (make-cnv-record :descr "emboss-filter" :width 3
                       :kernel '(-2.0 -1.0 0.0 -1.0 1.0 1.0 0.0 1.0 2.0) :divisor 1.0))
(setf (gethash 'sharpen *cnv-lib*)
      (make-cnv-record :descr "sharpen-filter" :width 3
                       :kernel '(-1.0 -1.0 -1.0 -1.0 9.0 -1.0 -1.0 -1.0 -1.0) :divisor 1.0))
(setf (gethash 'sobel-emboss *cnv-lib*)
      (make-cnv-record :descr "sobel-emboss-filter" :width 3
                       :kernel '(-1.0 -2.0 -1.0 0.0 0.0 0.0 1.0 2.0 1.0 :divisor 1.0 :offset 0.5)))
(setf (gethash 'box-blur *cnv-lib*)
      (make-cnv-record :descr "box-blur-filter" :width 3
                       :kernel '(1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0) :divisor 9.0))

(defun convolve (filename params)
  (let* ((buf (read-ppm-file-to-rgb-pixel-buffer filename))
         (width (first (array-dimensions buf)))
         (height (second (array-dimensions buf)))
         (obuf (make-rgb-pixel-buffer width height)))

    ;;; constrain a value to some range
    ;;; (int,int,int)->int
    (defun constrain (val minv maxv)
      (declare (type integer val minv maxv))
      (min maxv (max minv val)))

    ;;; convolve a single channel
    ;;; list ubyte8->ubyte8
    (defun convolve-channel (band)
      (constrain (round (apply #'+ (mapcar #'* band (cnv-record-kernel params)))) 0 255))

    ;;; return the rgb convolution of a list of pixels
    ;;; list uint24->uint24
    (defun convolve-pixels (pixels)
      (let ((reds (list)) (greens (list)) (blues (list)))
        (dolist (pel (reverse pixels))
          (push (rgb-pixel-red pel) reds)
          (push (rgb-pixel-green pel) greens)
          (push (rgb-pixel-blue pel) blues))
        (make-rgb-pixel (convolve-channel reds) (convolve-channel greens) (convolve-channel blues))))

    ;;; return the list of pixels to which the kernel will be applied
    ;;; (int,int)->list uint24
    (defun kernel-pixels (c r)
      (mapcar (lambda (coff roff) (rgb-pixel buf (constrain (+ c coff) 0 (1- width)) (constrain (+ r roff) 0 (1- height))))
              +col-offsets+ +row-offsets+))

    ;;; body of function
    (dotimes (r height)
      (dotimes (c width)
        (setf (rgb-pixel obuf c r) (convolve-pixels (kernel-pixels c r)))))

    (write-rgb-pixel-buffer-to-ppm-file (concatenate 'string (format nil "convolve-~A-" (cnv-record-descr params)) filename) obuf)))

(in-package #:cl-user)
(defun main ()
  (loop for pars being the hash-values of convolve::*cnv-lib*
    do (princ (convolve::convolve "lena_color.ppm" pars)) (terpri)))
