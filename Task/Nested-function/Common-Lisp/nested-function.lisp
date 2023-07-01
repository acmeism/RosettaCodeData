(defun my-make-list (separator)
  (let ((counter 0))
    (flet ((make-item (item)
              (format nil "~a~a~a~%" (incf counter) separator item)))
      (concatenate 'string
                   (make-item "first")
                   (make-item "second")
                   (make-item "third")))))

(format t (my-make-list ". "))
