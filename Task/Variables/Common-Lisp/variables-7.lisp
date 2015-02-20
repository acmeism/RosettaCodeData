(declaim (ftype (function (fixnum) fixnum) frobnicate))
(defun frobnicate (x)
  (declare (type fixnum x))
  (the fixnum (+ x 128)))
