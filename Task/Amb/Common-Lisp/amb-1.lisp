(define-condition amb-failure () ()
  (:report "No amb alternative succeeded."))

(defun invoke-ambiguously (function thunks)
  "Call function with successive values produced by successive
functions in thunks until some invocation of function does not signal
an amb-failure."
  (do ((thunks thunks (rest thunks)))
      ((endp thunks) (error 'amb-failure))
    (let ((argument (funcall (first thunks))))
      (handler-case (return (funcall function argument))
        (amb-failure ())))))

(defmacro amblet1 ((var form) &body body)
  "If form is of the form (amb {form}*) then amblet1 is a convenient
syntax for invoke-ambiguously, by which body is evaluated with var
bound the results of each form until some evaluation of body does not
signal an amb-failure. For any other form, amblet binds var the result
of form, and evaluates body."
  (if (and (listp form) (eq (first form) 'amb))
    `(invoke-ambiguously
      #'(lambda (,var) ,@body)
      (list ,@(loop for amb-form in (rest form)
                    collecting `#'(lambda () ,amb-form))))
    `(let ((,var ,form))
       ,@body)))

(defmacro amblet (bindings &body body)
  "Like let, except that if an init-form is of the form (amb {form}*),
then the corresponding var is bound with amblet1."
  (if (endp bindings)
    `(progn ,@body)
    `(amblet1 ,(first bindings)
       (amblet ,(rest bindings)
         ,@body))))
