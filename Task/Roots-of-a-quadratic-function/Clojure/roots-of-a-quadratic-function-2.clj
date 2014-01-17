; x = (b +- sqrt(b ^ 2 - 4 * a * c)) / (2 * a)
; local
(defn quad_func_sign [a b d sgn]
    (/ (if (< sgn 0.0)
            (- b (Math/sqrt d))
            (+ b (Math/sqrt d)) )
        (* 2.0 a) ))
