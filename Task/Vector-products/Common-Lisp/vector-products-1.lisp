(defclass 3d-vector ()
  ((x :type number :initarg :x)
   (y :type number :initarg :y)
   (z :type number :initarg :z)))

(defmethod print-object ((object 3d-vector) stream)
  (print-unreadable-object (object stream :type t)
    (with-slots (x y z) object
      (format stream "~a ~a ~a" x y z))))

(defun make-3d-vector (x y z)
  (make-instance '3d-vector :x x :y y :z z))

(defmethod dot-product ((a 3d-vector) (b 3d-vector))
  (with-slots ((a1 x) (a2 y) (a3 z)) a
    (with-slots ((b1 x) (b2 y) (b3 z)) b
      (+ (* a1 b1) (* a2 b2) (* a3 b3)))))

(defmethod cross-product ((a 3d-vector)
                                 (b 3d-vector))
  (with-slots ((a1 x) (a2 y) (a3 z)) a
    (with-slots ((b1 x) (b2 y) (b3 z)) b
      (make-instance '3d-vector
                     :x (- (* a2 b3) (* a3 b2))
                     :y (- (* a3 b1) (* a1 b3))
                     :z (- (* a1 b2) (* a2 b1))))))

(defmethod scalar-triple-product ((a 3d-vector)
                                  (b 3d-vector)
                                  (c 3d-vector))
  (dot-product a (cross-product b c)))

(defmethod vector-triple-product ((a 3d-vector)
                                  (b 3d-vector)
                                  (c 3d-vector))
  (cross-product a (cross-product b c)))

(defun vector-products-example ()
  (let ((a (make-3d-vector 3 4 5))
        (b (make-3d-vector 4 3 5))
        (c (make-3d-vector -5 -12 -13)))
    (values (dot-product a b)
            (cross-product a b)
            (scalar-triple-product a b c)
            (vector-triple-product a b c))))
