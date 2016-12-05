(def doors (* [False] 100))

(for [pass (range (len doors))]
  (for [i (range pass (len doors) (inc pass))]
    (assoc doors i (not (get doors i)))))

(for [i (range (len doors))]
  (print (.format "Door {} is {}."
    (inc i)
    (if (get doors i) "open" "closed"))))
