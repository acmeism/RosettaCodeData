(defun simple-moving-average (period &aux
    (sum 0) (count 0) (values (make-list period)) (pointer values))
  (setf (rest (last values)) values)  ; construct circularity
  (lambda (n)
    (when (first pointer)
      (decf sum (first pointer)))     ; subtract old value
    (incf sum n)                      ; add new value
    (incf count)
    (setf (first pointer) n)
    (setf pointer (rest pointer))     ; advance pointer
    (/ sum (min count period))))
