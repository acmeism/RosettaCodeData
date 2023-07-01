(defn update-map [base update]
  (merge base update))

  (update-map {"name"  "Rocket Skates"
               "price" "12.75"
               "color" "yellow"}
              {"price" "15.25"
               "color" "red"
               "year"  "1974"})
