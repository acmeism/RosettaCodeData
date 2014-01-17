; v1.2 return a list
(defn quad_func [a b c]
    (def d
        (- (* b b)
            (* 4 a c)) )
    (if (< d 0)
        (list)
        (if (> d 0)
            (list (quad_func_sign a b d -1)
                (quad_func_sign a b d +1))
            (list (quad_func_sign a b d +1)) )) )
