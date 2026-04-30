(import srfi/231)

(define (kronecker-product A B)
  (array-block (array-map (lambda (a) (array-map (lambda (b) (* a b)) B)) A)))

(define Cantor-base    (list*->array 1 '(1)))
(define Cantor-iterate (list*->array 1 '(1 0 1)))

(define (do-Cantor levels)
  (let loop ((l 0)
             (C_l Cantor-base))
    (if (<= l levels)
        (begin
          (array-for-each (lambda (entry)
                            (display (make-string (expt 3 (- levels l))
                                                  (if (positive? entry) #\* #\ ))))
                          C_l)
          (newline)
          (loop (+ l 1)
                (kronecker-product Cantor-iterate C_l))))))

(do-Cantor 4)
