(defn hickerson
  "Hickerson number, calculated with BigDecimals and manually-entered high-precision value for ln(2)."
  [n]
  (let [n! (apply *' (range 1M (inc n)))]
    (.divide n! (*' 2 (.pow 0.693147180559945309417232121458M (inc n)))
                30 BigDecimal/ROUND_HALF_UP)))

(defn almost-integer?
  "Tests whether the first digit after the decimal is 0 or 9."
  [x]
  (let [first-digit (int (mod (.divide (*' x 10) 1.0M 0 BigDecimal/ROUND_DOWN)
                              10))]
    (or (= 0 first-digit) (= 9 first-digit))))

; Execute for side effects
(doseq [n (range 1 18) :let [h (hickerson n)]]
  (println (format "%2d %24.5f" n h)
           (if (almost-integer? h)
             "almost integer"
             "NOT almost integer")))
