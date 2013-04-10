((defun select-nth (n list predicate)
  "Select nth element in list, ordered by predicate, modifying list."
  (do ((pivot (pop list))
       (ln 0) (left '())
       (rn 0) (right '()))
      ((endp list)
       (cond
        ((< n ln) (select-nth n left predicate))
        ((eql n ln) pivot)
        ((< n (+ ln rn 1)) (select-nth (- n ln 1) right predicate))
        (t (error "n out of range."))))
    (if (funcall predicate (first list) pivot)
      (psetf list (cdr list)
             (cdr list) left
             left list
             ln (1+ ln))
      (psetf list (cdr list)
             (cdr list) right
             right list
             rn (1+ rn)))))

(defun median (list predicate)
  (select-nth (floor (length list) 2) list predicate))
