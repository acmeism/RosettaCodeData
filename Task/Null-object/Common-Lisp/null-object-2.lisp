(defmethod car* ((arg cons))
  (car arg))

(defmethod car* ((arg null))
  nil)
