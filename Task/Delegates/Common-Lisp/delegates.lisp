(defgeneric thing (object)
  (:documentation "Thing the object."))

(defmethod thing (object)
  "default implementation")

(defclass delegator ()
  ((delegate
    :initarg :delegate
    :reader delegator-delegate)))

(defmethod thing ((delegator delegator))
  "If delegator has a delegate, invoke thing on the delegate,
otherwise return \"no delegate\"."
  (if (slot-boundp delegator 'delegate)
    (thing (delegator-delegate delegator))
    "no delegate"))

(defclass delegate () ())

(defmethod thing ((delegate delegate))
  "delegate implementation")

(let ((d1 (make-instance 'delegator))
      (d2 (make-instance 'delegator :delegate nil))
      (d3 (make-instance 'delegator :delegate (make-instance 'delegate))))
  (assert (string= "no delegate" (thing d1)))
  (assert (string= "default implementation" (thing d2)))
  (assert (string= "delegate implementation" (thing d3))))
