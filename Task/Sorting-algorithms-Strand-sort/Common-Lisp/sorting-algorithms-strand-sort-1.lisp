(defun strand-sort (l cmp)
  (if l
    (let* ((l (reverse l))
	   (o (list (car l))) n)
      (loop for i in (cdr l) do
	    (push i (if (funcall cmp (car o) i) n o)))
      (merge 'list o (strand-sort n cmp) #'<))))

(let ((r (loop repeat 15 collect (random 10))))
  (print r)
  (print (strand-sort r #'<)))
