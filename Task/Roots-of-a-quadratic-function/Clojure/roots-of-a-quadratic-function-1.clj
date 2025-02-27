(defn quadratic
  "Compute the roots of a quadratic in the form ax^2 + bx + c = 1.
   Returns any of nil, a float, or a vector."
  [a b c]
  (let [sq-d (Math/sqrt (- (* b b) (* 4 a c)))
        f    #(/ (% (- b) sq-d) (* 2 a))]
    (cond
       (neg? sq-d)  nil
       (zero? sq-d) (f +)
       (pos? sq-d)  [(f +) (f -)]
       :else nil))) ; maybe our number ended up as NaN
