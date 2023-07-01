(defclass circle ()
  ((radius :initarg :radius
           :initform 1.0
           :type number
           :reader radius)))

(defmethod area ((shape circle))
  (* pi (expt (radius shape) 2)))

> (defvar *c* (make-instance 'circle :radius 2))
> (area *c*)
12.566370614359172d0
