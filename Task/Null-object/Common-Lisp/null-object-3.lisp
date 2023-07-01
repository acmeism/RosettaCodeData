(defmethod car* ((arg t))  ;; can just be written (defmethod car* (arg) ...)
  (error "CAR*: ~s is neither a cons nor nil" arg))
