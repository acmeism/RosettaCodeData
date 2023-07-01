(defun add (p1 p2)
  (do ((sum '())) ((and (endp p1) (endp p2)) (nreverse sum))
    (let ((pd1 (if (endp p1) -1 (caar p1)))
          (pd2 (if (endp p2) -1 (caar p2))))
      (multiple-value-bind (c1 c2)
          (cond
           ((> pd1 pd2) (values (cdr (pop p1)) 0))
           ((< pd1 pd2) (values 0 (cdr (pop p2))))
           (t  (values (cdr (pop p1)) (cdr (pop p2)))))
        (let ((csum (+ c1 c2)))
          (unless (zerop csum)
            (setf sum (acons (max pd1 pd2) csum sum))))))))

(defun multiply (p1 p2)
  (flet ((*p2 (p)
           (destructuring-bind (d . c) p
             (loop for (pd . pc) in p2
                   collecting (cons (+ d pd) (* c pc))))))
    (reduce 'add (mapcar #'*p2 p1) :initial-value '())))

(defun subtract (p1 p2)
  (add p1 (multiply '((0 . -1)) p2)))

(defun divide (dividend divisor &aux (sum '()))
  (assert (not (endp divisor)) (divisor)
    'division-by-zero
    :operation 'divide
    :operands (list dividend divisor))
  (flet ((floor1 (dividend divisor)
           (if (endp dividend) (values '() ())
             (destructuring-bind (d1 . c1) (first dividend)
               (destructuring-bind (d2 . c2) (first divisor)
                 (if (> d2 d1) (values '() dividend)
                   (let* ((quot (list (cons (- d1 d2) (/ c1 c2))))
                          (rem (subtract dividend (multiply divisor quot))))
                     (values quot rem))))))))
    (loop (multiple-value-bind (quotient remainder)
              (floor1 dividend divisor)
            (if (endp quotient) (return (values sum remainder))
              (setf dividend remainder
                    sum (add quotient sum)))))))
