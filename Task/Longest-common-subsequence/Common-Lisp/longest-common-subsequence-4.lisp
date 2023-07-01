(defmacro mem-defun (name args body)
  (let ((hash-name (gensym)))
    `(let ((,hash-name (make-hash-table :test 'equal)))
       (defun ,name ,args
         (or (gethash (list ,@args) ,hash-name)
             (setf (gethash (list ,@args) ,hash-name)
                   ,body))))))

(mem-defun lcs (xs ys)
  (labels ((longer (a b) (if (> (length a) (length b)) a b)))
     (cond ((or (null xs) (null ys)) nil)
           ((equal (car xs) (car ys)) (cons (car xs) (lcs (cdr xs) (cdr ys))))
	   (t (longer (lcs (cdr xs) ys)
		      (lcs xs (cdr ys)))))))
