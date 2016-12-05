;; copied from Racket

(for*/list ([x (in-range 1 21)]
[y (in-range x 21)]
[z (in-range y 21)])
#:when (= (+ (* x x) (* y y)) (* z z))
(list x y z))
    → ((3 4 5) (5 12 13) (6 8 10) (8 15 17) (9 12 15) (12 16 20))
