(defun comb (m n (i . 0))
  (cond ((zerop m) '(()))
        ((eq i n) '())
        (t (append
              (mapc '(lambda (rest) (cons i rest))
                    (comb (sub1 m) n (add1 i)))
              (comb m n (add1 i))))))

(defun append (a b)
  (cond ((null a) b)
        (t (cons (car a) (append (cdr a) b)))))

(map print (comb 3 5))
