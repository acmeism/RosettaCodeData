(defn n-th [n]
  (str n
    (let [rem (mod n 100)]
      (if (and (>= rem 11) (<= rem 13))
        "th"
        (condp = (mod n 10)
          1 "st"
          2 "nd"
          3 "rd"
          "th")))))

(apply str (interpose " " (map n-th (range 0 26))))
(apply str (interpose " " (map n-th (range 250 266))))
(apply str (interpose " " (map n-th (range 1000 1026))))
