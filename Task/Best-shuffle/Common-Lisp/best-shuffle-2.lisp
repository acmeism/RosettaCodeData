(defun all-best-shuffles (str)
  (let (tbl out (shortest (length str)) (s str))

    (labels ((perm (ar l tmpl res overlap)
               (when (> overlap shortest)
                 (return-from perm))
               (when (zerop l) ; max depth of perm
                 (when (< overlap shortest)
                   (setf shortest overlap out '()))
                 (when (= overlap shortest)
                   (setf res (reverse (format nil "~{~c~^~}" res)))
                   (push (list res overlap) out)
                   (return-from perm)))
               (decf l)
               (dolist (x ar)
                 (when (plusp (cdr x))
                   (when (char= (car x) (char tmpl l))
                     (incf overlap))
                   (decf (cdr x))
                   (push (car x) res)
                   (perm ar l tmpl res overlap)
                   (pop res)
                   (incf (cdr x))
                   (when (char= (car x) (char tmpl l))
                     (decf overlap))))))

      (loop while (plusp (length s)) do
            (let* ((c (char s 0))
                   (l (count c s)))
              (push (cons c l) tbl)
              (setf s (remove c s))))

      (perm tbl (length str) (reverse str) '() 0))
    out))

(defun best-shuffle (str)
  "Algorithm: list all best shuffles, then pick one"
  (let ((c (all-best-shuffles str)))
    (elt c (random (length c)))))

(format t "All best shuffles:")
(print (all-best-shuffles "seesaw"))

(format t "~%~%Random best shuffles:~%")
(dolist (s (list "abracadabra" "seesaw" "elk" "grrrrrr" "up" "a"))
  (format t "~A: ~A~%" s (best-shuffle s)))
