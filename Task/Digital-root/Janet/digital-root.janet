(defn numbers [s] (filter (fn [y] (and (<= y 9) (>= y 0))) (map (fn [z] (- z 48)) (string/bytes s))))
(defn summa [s] (reduce (fn [x y] (+ x y)) 0 (numbers s)))
(defn minsumma [x p]
  (if (<= x 9)
    [x p]
    (minsumma (summa (string/format "%d" x)) (+ 1 p))))
(defn test [t] (printf "%j" (minsumma (summa t) 1)))
(test "627615")
(test "39390")
(test "588225")
(test "393900588225")
(test "19999999999999999999999999999999999999999999999999999999999999999999999999999999999999")
(test "192348-0347203478-20483298402-39482-04720348-20394823-058720375204820-394823842-049802-93482-034892-3")
