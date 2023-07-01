(defgeneric do-something (thing)
  (:documentation "Do something to thing."))

(defmethod no-applicable-method ((method (eql #'do-something)) &rest args)
  (format nil "No method for ~w on ~w." method args))

(defmethod do-something ((thing (eql 3)))
  (format nil "Do something to ~w." thing))
