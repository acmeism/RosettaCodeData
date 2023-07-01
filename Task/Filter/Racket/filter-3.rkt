-> (for/list ([x '(0 1 2 3 4 5 6 7 8 9)] #:when (even? x)) x)
'(0 2 4 6 8)
