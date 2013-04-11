(defun pascal (n)
   (genrow n '(1)))

(defun genrow (n l)
   (when (< 0 n)
       (print l)
       (genrow (1- n) (cons 1 (newrow l)))))

(defun newrow (l)
   (if (> 2 (length l))
      '(1)
      (cons (+ (car l) (cadr l)) (newrow (cdr l)))))
