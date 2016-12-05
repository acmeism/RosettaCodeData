(defun quadratic-mean (xs)
    (sqrt
        (/
            (apply +
                (mapcar (lambda (x) (expt x 2)) xs))
            (length xs))))

; define a RANGE function, for testing purposes

(defun range (x y)
    (if (< x y)
        (cons x (range (+ x 1) y))))

; test QUADRATIC-MEAN

(print (quadratic-mean (range 1 11)))
