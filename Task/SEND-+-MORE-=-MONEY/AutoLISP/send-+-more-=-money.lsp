(defun c:SMM ( / Unique syms i digits
                 m s e n d o r y send more money)
  (defun Unique (lst)
    (if lst
      (cons (car lst)
            (Unique (vl-remove (car lst) (cdr lst))))))

  (setq syms '(m s e n d o r y))     ; 8 symbols
  (setq i (- 18234567 1))            ; highest possible starting integer for syms
  (while  (<= (setq i (1+ i))
              19876543)              ; highest possible value for syms
    (setq digits (vl-string->list (itoa i)))       ; list of ascii codes of i's digits
    (if (= 8 (length (Unique digits)))             ; all digits are unique
      (progn
          (mapcar 'set syms
                       (mapcar 'chr digits))       ; back to 1-char strings
          (mapcar '(lambda (v x)
                           (set v                           ; (set 'more
                                (atoi (apply 'strcat x))))  ;     "1234" --> 1234 )
                  '(send more money)
                   (list (list    s e n d)
                         (list    m o r e)                  ; '( "1" "2" "3" "4")
                         (list  m o n e y)))
          (if (= (+ send more) money)
              (princ
                (strcat
                  "\n" (itoa send) " + " (itoa more) " = " (itoa money)))))))
  (princ))
