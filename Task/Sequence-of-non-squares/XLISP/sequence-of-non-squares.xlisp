(defun non-square (n)
    (+ n (floor (+ 0.5 (sqrt n)))))

(defun range (x y)
    (if (< x y)
        (cons x (range (+ x 1) y))))

(defun squarep (x)
    (= x (expt (floor (sqrt x)) 2)))

(defun count-squares (x y)
    (define squares 0)
    (if (squarep (non-square x))
        (define squares (+ squares 1)))
    (if (= x y)
        squares
        (count-squares (+ x 1) y)))

(print (mapcar non-square (range 1 23)))

(print `(number of squares for values less than 1000000 = ,(count-squares 1 1000000)))
