(defun comb-recurse (m n n-max)
  (cond ((zerop m) '(()))
        ((= n-max n) '())
        (t (append (mapcar #'(lambda (rest) (cons n rest))
                           (comb-recurse (1- m) (1+ n) n-max))
                   (comb-recurse m (1+ n) n-max)))))

(defun comb (m n)
  (comb-recurse m 0 n))

(comb 3 5)
