(defun rc-create-variable (name initial-value)
  "Create a global variable whose name is NAME in the current package and which is bound to INITIAL-VALUE."
  (let ((symbol (intern name)))
    (proclaim `(special ,symbol))
    (setf (symbol-value symbol) initial-value)
    symbol))
