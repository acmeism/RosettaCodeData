(import
  [numpy [ones column-stack]]
  [numpy.random [randn]]
  [numpy.linalg [lstsq]])

(setv n 1000)
(setv x1 (randn n))
(setv x2 (randn n))
(setv y (+ 3 (* 1 x1) (* -2 x2) (* .25 x1 x2) (randn n)))

(print (first (lstsq
  (column-stack (, (ones n) x1 x2 (* x1 x2)))
  y)))
