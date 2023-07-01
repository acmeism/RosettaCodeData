(define my-table '(("" X Y Z) (-1111 111 11) (22 -222 2222) (4422 0  42) (33 333 3333) (6666 666 66)))

(stack (define html 'html)) ;; stack of html elements
(emit-tag 'table h-table my-table)
(string-join (stack->list html) " ")
