; builtin function
(max 1 2 3 4 5) ; 5

(define x '(1 2 3 4 5))

; using to numbers list
(apply max x) ; 5

; using list reducing
(fold max (car x) x) ; 5

; manual lambda-comparator
(print (fold (lambda (a b)
   (if (less? a b) b a))
   (car x) x)) ; 5
