(defun range (from to)
  (cond ((greaterp from to) '())
        (t (cons from (range (add1 from) to)))))

(defun example ()
  (mapc '(lambda (f) (f))
        (mapc '(lambda (i)
                 (freeze '(i) '(lambda () (times i i))))
              (range 1 10))))
