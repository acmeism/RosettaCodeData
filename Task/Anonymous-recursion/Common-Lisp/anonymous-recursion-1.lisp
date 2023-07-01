(defmacro alambda (parms &body body)
  `(labels ((self ,parms ,@body))
     #'self))
