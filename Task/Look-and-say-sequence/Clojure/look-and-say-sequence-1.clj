(defn digits-seq
  "Returns a seq of the digits of a number (L->R)."
  [n]
  (loop [digits (), number n]
    (if (zero? number) (seq digits)
        (recur (cons (mod number 10) digits)
               (quot number 10)))))

(defn join-digits
  "Converts a digits-seq back in to a number."
  [ds]
  (reduce (fn [n d] (+ (* 10 n) d)) ds))

(defn look-and-say [n]
  (->> n digits-seq (partition-by identity)
       (mapcat (juxt count first)) join-digits))
