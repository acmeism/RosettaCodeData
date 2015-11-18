(defun power-set (s)
  (reduce #'(lambda (item ps)
              (append (mapcar #'(lambda (e) (cons item e))
                              ps)
                      ps))
          s
          :from-end t
          :initial-value '(())))
