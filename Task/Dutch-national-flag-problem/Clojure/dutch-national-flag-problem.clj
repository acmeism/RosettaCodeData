(defn dutch-flag-order [color]
  (get {:red 1 :white 2 :blue 3} color))

(defn sort-in-dutch-flag-order [balls]
  (sort-by dutch-flag-order balls))

;; Get a collection of 'n' balls of Dutch-flag colors
(defn random-balls [num-balls]
  (repeatedly num-balls
              #(rand-nth [:red :white :blue])))

;; Get random set of balls and insure they're not accidentally sorted
(defn starting-balls [num-balls]
  (let [balls (random-balls num-balls)
        in-dutch-flag-order? (= balls
                                (sort-in-dutch-flag-order balls))]
    (if in-dutch-flag-order?
      (recur num-balls)
      balls)))
