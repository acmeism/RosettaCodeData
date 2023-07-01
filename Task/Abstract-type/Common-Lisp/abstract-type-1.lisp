(defgeneric kar (kons)
  (:documentation "Return the kar of a kons."))

(defgeneric kdr (kons)
  (:documentation "Return the kdr of a kons."))

(defun konsp (object &aux (args (list object)))
  "True if there are applicable methods for kar and kdr on object."
  (not (or (endp (compute-applicable-methods #'kar args))
           (endp (compute-applicable-methods #'kdr args)))))

(deftype kons ()
  '(satisfies konsp))
