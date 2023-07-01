(defn gcd*
  "greatest common divisor of a list of numbers"
  [& lst]
  (reduce gcd
          lst))
