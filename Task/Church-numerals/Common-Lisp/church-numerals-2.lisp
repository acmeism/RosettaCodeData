(defvar zero (lambda (f) (lambda (x) x)))

(defun succ (n) (lambda (f) (compose f (funcall n f))))

(defun plus (m n)
  (lambda (f) (compose (funcall m f) (funcall n f))))

(defun times (m n)
  (compose m n))

(defun power (m n)
  (funcall n m))

(defun compose (f g)
  (lambda (x) (funcall f (funcall g x))))

(defun church (i)    ; int -> Church
  (if (zerop i) zero (succ (church (1- i)))))

(defun unchurch (n)  ; Church -> int
  (funcall (funcall n #'1+) 0))
