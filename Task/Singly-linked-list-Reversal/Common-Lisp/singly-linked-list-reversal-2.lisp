(defun my-reverse (list)
  (reduce #'(lambda (acc x)
              (cons x acc))
          list
          :initial-value NIL))
