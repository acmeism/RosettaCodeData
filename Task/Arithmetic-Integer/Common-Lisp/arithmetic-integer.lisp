(defun arithmetic (&optional (a (read *query-io*)) (b (read *query-io*)))
  (mapc
    (lambda (op)
      (format t "~a => ~a~%" (list op a b) (funcall (symbol-function op) a b)))
    '(+ - * mod rem floor ceiling truncate round expt))
  (values))
