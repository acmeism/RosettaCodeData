(defun is-zero (n)
  (funcall n (lambda (x) false) true))

(defun divide (m n)
  (divide1 (succ m) n))

(defun divide1 (m n)
  (let ((d (minus m n)))
    (church-if (is-zero d)
        zero
      (succ (divide1 d n)))))
