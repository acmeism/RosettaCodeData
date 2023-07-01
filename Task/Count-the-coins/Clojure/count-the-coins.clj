(def denomination-kind [1 5 10 25])

(defn- cc [amount denominations]
  (cond (= amount 0) 1
        (or (< amount 0) (empty? denominations)) 0
        :else (+ (cc amount (rest denominations))
                 (cc (- amount (first denominations)) denominations))))

(defn count-change
  "Calculates the number of times you can give change with the given denominations."
  [amount denominations]
  (cc amount denominations))

(count-change 15 denomination-kind) ; = 6
