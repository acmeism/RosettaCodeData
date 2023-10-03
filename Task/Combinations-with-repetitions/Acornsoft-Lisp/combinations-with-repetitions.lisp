(defun samples (k items)
  (cond
    ((zerop k) '(()))
    ((null items) '())
    (t (append
          (mapc '(lambda (c) (cons (car items) c))
                (samples (sub1 k) items))
          (samples k (cdr items))))))

(defun append (a b)
  (cond ((null a) b)
        (t (cons (car a) (append (cdr a) b)))))

(defun length (list (len . 0))
  (map '(lambda (e) (setq len (add1 len)))
       list)
  len)
