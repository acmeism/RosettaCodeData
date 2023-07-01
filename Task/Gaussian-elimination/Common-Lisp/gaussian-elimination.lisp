(defmacro mapcar-1 (fn n list)
 "Maps a function of two parameters where the first one is fixed, over a list"
  `(mapcar #'(lambda (l) (funcall ,fn ,n l)) ,list) )


(defun gauss (m)
  (labels
    ((redc (m) ; Reduce to triangular form
       (if (null (cdr m))
         m
        (cons (car m) (mapcar-1 #'cons 0 (redc (mapcar #'cdr (mapcar #'(lambda (r) (mapcar #'- (mapcar-1 #'* (caar m) r)
                                                                                            (mapcar-1 #'* (car r) (car m)))) (cdr m)))))) ))
     (rev (m) ; Reverse each row except the last element
       (reverse (mapcar #'(lambda (r) (append (reverse (butlast r)) (last r))) m)) ))
    (catch 'result
      (let ((m1 (redc (rev (redc m)))))
        (reverse (mapcar #'(lambda (r) (let ((pivot (find-if-not #'zerop r))) (if pivot (/ (car (last r)) pivot) (throw 'result 'singular)))) m1)) ))))
