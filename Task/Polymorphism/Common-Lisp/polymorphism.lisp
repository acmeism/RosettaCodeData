(defclass point ()
  ((x :initarg :x :initform 0 :accessor x)
   (y :initarg :y :initform 0 :accessor y)))

(defclass circle (point)
  ((radius :initarg :radius :initform 0 :accessor radius)))

(defgeneric shallow-copy (object))
(defmethod shallow-copy ((p point))
  (make-instance 'point :x (x p) :y (y p)))
(defmethod shallow-copy ((c circle))
  (make-instance 'circle :x (x c) :y (y c) :radius (radius c)))

(defgeneric print-shape (shape))
(defmethod print-shape ((p point))
  (print 'point))
(defmethod print-shape ((c circle))
  (print 'circle))

(let ((p (make-instance 'point :x 10))
      (c (make-instance 'circle :radius 5)))
  (print-shape p)
  (print-shape c))
