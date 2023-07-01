(defn luhn? [cc]
  (let [sum (->> cc
                 (map #(Character/digit ^char % 10))
                 reverse
                 (map * (cycle [1 2]))
                 (map #(+ (quot % 10) (mod % 10)))
                 (reduce +))]
    (zero? (mod sum 10))))

(defn is-valid-isin? [isin]
  (and (re-matches #"^[A-Z]{2}[A-Z0-9]{9}[0-9]$" isin)
       (->> isin
            (map #(Character/digit ^char % 36))
            (apply str)
            luhn?)))

(use 'clojure.pprint)
(doseq [isin ["US0378331005" "US0373831005" "U50378331005" "US03378331005"
              "AU0000XVGZA3" "AU0000VXGZA3" "FR0000988040"]]
  (cl-format *out* "~A: ~:[invalid~;valid~]~%" isin (is-valid-isin? isin)))
