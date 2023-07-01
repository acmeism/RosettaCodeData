(defun bar (n)
  "Add 3 to the argument."
  (+ n 3))

(defclass button (widget)
  (label action)
  (:documentation "This is a push-button widget."))
