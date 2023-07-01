[1]> (defun add-sub (x y) (values-list (list (+ x y) (- x y))))
ADD-SUB
[2]> (add-sub 4 2)    ; 6 (primary) and 2
6 ;
2
[3]> (add-sub 3 1)    ; 4 (primary) and 2
4 ;
2
[4]> (+ (add-sub 4 2) (add-sub 3 1))  ; 6 + 4
10
[5]> (multiple-value-call #'+ (add-sub 4 2) (add-sub 3 1)) ; 6+2+4+2
14
