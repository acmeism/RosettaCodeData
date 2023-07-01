;; Example 1:
(setf A (make-array '(3 3) :initial-contents '((25 15 -5) (15 18 0) (-5 0 11))))
(chol A)
#2A((5.0 0 0)
    (3.0 3.0 0)
    (-1.0 1.0 3.0))
