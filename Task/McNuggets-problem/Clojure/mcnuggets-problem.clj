(defn cart [colls]
  (if (empty? colls)
    '(())
    (for [more (cart (rest colls))
          x (first colls)]
      (cons x more))))

(defn nuggets [[n6 n9 n20]] (+ (* 6 n6) (* 9 n9) (* 20 n20)))

(let [possible (distinct (map nuggets (cart (map range [18 13 6]))))
      mcmax (apply max (filter (fn [x] (not-any? #{x} possible)) (range 101)))]
  (printf "Maximum non-McNuggets number is %d\n" mcmax))
