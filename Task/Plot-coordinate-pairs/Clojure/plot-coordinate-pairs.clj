(use '(incanter core stats charts))
(def x (range 0 10))
(def y '(2.7 2.8 31.4 38.1 58.0 76.2 100.5 130.0 149.3 180.0))
(view (xy-plot x y))
