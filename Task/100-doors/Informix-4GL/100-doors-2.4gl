(var doors (times 100 false))

(for i  (range 1 101)
     i2 (range (dec i) 100 i)
  (var! doors (set-at [i2] (! (i2 doors))))
  (continue))

(-> (xmap vec doors)
    (filter 1)
    (map (comp 0 inc))
    (join ", ")
   @(str "open doors: "))
