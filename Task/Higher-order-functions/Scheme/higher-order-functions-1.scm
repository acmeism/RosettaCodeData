> (define (func1 f) (f "a string"))
> (define (func2 s) (string-append "func2 called with " s))
> (begin (display (func1 func2)) (newline))
func2 called with a string
