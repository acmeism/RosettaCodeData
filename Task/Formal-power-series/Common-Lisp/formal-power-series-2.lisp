(defstruct promise
  thunk value)

(defmacro delay (form)
  `(make-promise :thunk #'(lambda () ,form)))

(defun force (object)
  (cond
   ((not (promise-p object))
    object)
   ((null (promise-thunk object))
    (promise-value object))
   (t (let ((val (funcall (promise-thunk object))))
        (setf (promise-thunk object) nil
              (promise-value object) val)))))
