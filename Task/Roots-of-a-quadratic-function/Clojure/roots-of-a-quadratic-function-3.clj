; v1.1 if solutions: 0, nil; 1, float; 2, list
(defn quad_func_1_1 [a b c]
    (def d
        (- (* b b)
            (* 4 a c)) )
    (if (< d 0)
        nil
        (if (> d 0)
            (list  (quad_func_sign a b d -1)
                (quad_func_sign a b d +1))
            (quad_func_sign a b d +1)) ))
