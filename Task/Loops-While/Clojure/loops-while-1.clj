(def i (ref 1024))

(while (> @i 0)
  (println @i)
  (dosync (ref-set i (quot @i 2))))
