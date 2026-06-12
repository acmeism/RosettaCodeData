(defun my-nreverse (list)
  ;; (cdr nil) is nil in Common Lisp, so (cdr list) is always safe.
  (do ((next (cdr list) (cdr next))
       (cur list next)
       (prev nil cur))
      ((endp cur) prev)
    (setf (cdr cur) prev)))
