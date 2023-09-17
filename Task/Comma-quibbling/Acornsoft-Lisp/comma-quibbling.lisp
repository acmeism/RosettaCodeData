(defun examples ()
  (map '(lambda (words) (printc (quibble words)))
       '(() (ABC) (ABC DEF) (ABC DEF G H))))

(defun quibble (words)
  (implode (list '{ (quibbles words) '})))

(defun quibbles (words)
  (implode (conjunction words)))

(defun conjunction (words)
  (cond ((null words)
         '())
        ((null (cdr words))
         words)
        ((null (cddr words))
         (list (car words) '! and!  (cadr words)))
        (t
         (cons (car words)
           (cons ',!  (conjunction (cdr words)))))))
