(defn to-celsius [k]
  (- k 273.15))
(defn to-fahrenheit [k]
  (- (* k 1.8) 459.67))
(defn to-rankine [k]
  (* k 1.8))

(defn temperature-conversion [k]
  (if (number? k)
    (format "Celsius: %.2f Fahrenheit: %.2f Rankine: %.2f"
      (to-celsius k) (to-fahrenheit k) (to-rankine k))
    (format "Error: Non-numeric value entered.")))
