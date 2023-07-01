(defclass my-class ()
  ((x
    :accessor get-x  ;; getter function
    :initarg :x      ;; arg name
    :initform 0)))   ;; initial value

;; declaring a public class method
(defmethod square-x ((class-instance my-class))
  (* (get-x class-instance) (get-x class-instance)))

;; create an instance of my-class
(defvar *instance*
  (make-instance 'my-class :x 10))

(format t "Value of x: ~a~%" (get-x *instance*))

(format t "Value of x^2: ~a~%" (square-x *instance*))
