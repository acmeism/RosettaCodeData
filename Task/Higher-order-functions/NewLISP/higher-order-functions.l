> (define (my-multiply a b) (* a b))
(lambda (a b) (* a b))
> (define (call-it f x y) (f x y))
(lambda (f x y) (f x y))
> (call-it my-multiply 2 3)
6
