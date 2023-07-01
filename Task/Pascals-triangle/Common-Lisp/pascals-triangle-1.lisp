(defun pascal (n)
  (genrow n '(1)))

(defun genrow (n l)
  (when (plusp n)
    (print l)
    (genrow (1- n) (cons 1 (newrow l)))))

(defun newrow (l)
  (if (null (rest l))
      '(1)
      (cons (+ (first l) (second l))
            (newrow (rest l)))))
