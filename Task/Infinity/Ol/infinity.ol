(define (infinite? x) (or (equal? x +inf.0) (equal? x -inf.0)))

(infinite? +inf.0) ==> #true
(infinite? -inf.0) ==> #true
(infinite? +nan.0) ==> #false
(infinite? 123456) ==> #false
(infinite? 1/3456) ==> #false
(infinite? 17+28i) ==> #false
