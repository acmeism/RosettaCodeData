(defun print-on-separate-lines (&rest xs)
    (for-each print xs))

; test the function:

(print-on-separate-lines 'i 'am 'doing 'a 'great 'work 'so 'that 'i 'cannot 'come 'down)

; to use it on a list of arguments assembled at run time, first create your list

(define test '(why should the work cease whilst i leave it and come down to you))

; and then call APPLY:

(apply print-on-separate-lines test)
