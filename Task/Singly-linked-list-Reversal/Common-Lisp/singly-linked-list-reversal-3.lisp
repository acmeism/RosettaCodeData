(defun my-nreverse (list)
  (labels ((iter (prev cur)
             (if (endp cur)
                 prev
                 (let ((next (cdr cur)))
                   (setf (cdr cur) prev)
                   (iter cur next)))))
    (iter nil list)))
