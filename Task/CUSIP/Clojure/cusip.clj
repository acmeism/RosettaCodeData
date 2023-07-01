(defn- char->value
  "convert the given char c to a value used to calculate the cusip check sum"
  [c]
  (let [int-char (int c)]
    (cond
      (and (>= int-char (int \0)) (<= int-char (int \9))) (- int-char 48)
      (and (>= int-char (int \A)) (<= int-char (int \Z))) (- int-char 55)
      (= c \*) 36
      (= c \@) 37
      (= c \#) 38
      :else nil)))

(defn- calc-sum
  "Calculate cusip sum. nil is returned for an invalid cusip."
  [cusip]
  (reduce
    (fn [sum [i c]]
      (if-let [v (char->value c)]
        (let [v (if (= (mod i 2) 1) (* v 2) v)]
          (+ sum (int (+ (/ v 10) (mod v 10)))))
        (reduced nil)))
    0
    (map-indexed vector (subs cusip 0 8))))

(defn calc-cusip-checksum
  "Given a valid 8 or 9 digit cusip, return the 9th checksum digit"
  [cusip]
  (when (>= (count cusip) 8)
    (let [sum (calc-sum cusip)]
      (when sum
        (mod (- 10 (mod sum 10)) 10)))))

(defn is-valid-cusip9?
  "predicate validating a 9 digit cusip."
  [cusip9]
  (when-let [checksum (and (= (count cusip9) 9)
                           (calc-cusip-checksum cusip9))]
    (= (- (int (nth cusip9 8)) 48)
       checksum)))

(defn rosetta-output
  "show some nice output for the Rosetta Wiki"
  []
  (doseq [cusip ["037833100" "17275R102" "38259P508" "594918104" "68389X106" "68389X105" "EXTRACRD8"
                 "EXTRACRD9" "BADCUSIP!" "683&9X106" "68389x105" "683$9X106" "68389}105" "87264ABE4"]]
    (println cusip (if (is-valid-cusip9? cusip) "valid" "invalid"))))
