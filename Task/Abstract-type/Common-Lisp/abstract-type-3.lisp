(defmethod kar ((n integer))
  1)

(defmethod kdr ((n integer))
  (if (zerop n) nil
    (1- n)))

(konsp 45)         ; => t
(typep 45 'kons)   ; => t
(kar 45)           ; => 1
(kdr 45)           ; => 44
