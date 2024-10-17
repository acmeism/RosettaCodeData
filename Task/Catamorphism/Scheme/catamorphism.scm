(define (reduce fn init lst)
  (do ((val init (fn (car rem) val)) ; accumulated value passed as second argument
       (rem lst (cdr rem)))
    ((null? rem) val)))

(display (reduce + 0 '(1 2 3 4 5))) (newline) ; => 15
(display (reduce expt 2 '(3 4))) (newline)    ; => 262144
