(def neg-inf (/ -1.0 0.0)) ; Also Double/NEGATIVE_INFINITY
(def inf (/ 1.0 0.0))      ; Also Double/POSITIVE_INFINITY
(def nan (/ 0.0 0.0))      ; Also Double/NaN
(def neg-zero (/ -2.0 Double/POSITIVE_INFINITY))   ; Also -0.0
(println "  Negative inf: " neg-inf)
(println "  Positive inf: " inf)
(println "           NaN: " nan)
(println "    Negative 0: " neg-zero)
(println "    inf + -inf: " (+ inf neg-inf))
(println "    NaN == NaN: " (= Double/NaN Double/NaN))
(println "NaN equals NaN: " (.equals Double/NaN Double/NaN))
