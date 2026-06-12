(defun c:SMM ( / Unique syms cnt numList smmList m s e n d o r y send more money)
  (defun Unique (lst)
    (if lst (cons (car lst) (Unique (vl-remove (car lst) (cdr lst)))))
  )
  (setq syms '(m s e n d o r y))
  (setq cnt 18234567) ;; highest possible starting integer for syms
  (repeat (- 19876543 cnt) ;; highest possible num sequence for syms
    (setq numList (vl-string->list (itoa cnt)))
    (if (= 8 (length (Unique numList)))
      (progn
        (mapcar 'set
          syms
          (mapcar 'chr numList)
        )
        (setq smmList
          (mapcar
           '(lambda (x) (apply 'strcat (mapcar 'eval x)))
           '((s e n d) (m o r e) (m o n e y))
          )
        )
        (mapcar
         '(lambda (v i) (set v (atoi i)))
         '(send more money)
         smmList
        )
        (if (= (+ send more) money)
          (prompt
            (strcat
              "\n" (car smmList) " + " (cadr smmList) " = " (caddr smmList)
            )
          )
        )
      );progn
    );if
    (setq cnt (1+ cnt))
  );repeat
  (princ)
)
