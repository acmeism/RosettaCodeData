(defun pred (n)
  (flet ((value (v) (lambda (h) (funcall h v)))
         (extract (k) (funcall k (lambda (u) u))))
    (lambda (f)
      (lambda (x)
        (let ((inc (lambda (g) (value (funcall g f))))
              (const (lambda (u) x)))
          (extract (funcall (funcall n inc) const)))))))

(defun minus (m n)
  (funcall (funcall n #'pred) m))

...

(defun is-zero (n)
  (funcall (funcall n (lambda (x) false)) true))

...
