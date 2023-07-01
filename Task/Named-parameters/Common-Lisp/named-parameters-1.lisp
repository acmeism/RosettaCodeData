(defun print-name (&key first (last "?"))
  (princ last)
  (when first
    (princ ", ")
    (princ first))
  (values))
