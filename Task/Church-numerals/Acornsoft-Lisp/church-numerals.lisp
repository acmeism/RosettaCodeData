(setq zero '(lambda (f x) x))

(defun succ (n)
  (freeze '(n) '(lambda (f x) (f (n f x)))))

(defun add (m n)
  (freeze '(m n) '(lambda (f x) (m f (n f x)))))

(defun mul (m n)
  (n (freeze '(m) '(lambda (sum) (add m sum))) zero))

(defun pow (m n)
  (n (freeze '(m) '(lambda (product) (mul m product))) one))

(defun church (i)
  (cond ((zerop i) zero)
        (t (succ (church (sub1 i))))))

(defun unchurch (n)
  (n add1 0))

(setq one (succ zero))
(setq two (succ one))
(setq three (succ two))
(setq four (succ three))

(defun show (example)
  (prin example)
  (princ '! =>! )
  (print (unchurch (eval example))))

(defun examples ()
  (show '(church 3))
  (show '(add three four))
  (show '(mul three four))
  (show '(pow three four))
  (show '(pow four three))
  (show '(pow (pow two two) (add two one))))
