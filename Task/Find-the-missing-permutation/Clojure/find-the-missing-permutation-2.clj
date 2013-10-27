(def abcds ["ABCD" "CABD" "ACDB" "DACB" "BCDA" "ACBD" "ADCB" "CDAB"
            "DABC" "BCAD" "CADB" "CDBA" "CBAD" "ABDC" "ADBC" "BDCA"
            "DCBA" "BACD" "BADC" "BDAC" "CBDA" "DBCA" "DCAB"])

(def freqs (->> abcds (apply map vector) (map frequencies)))

(defn v->k [fqmap v] (->> fqmap (filter #(-> % second (= v))) ffirst))

(->> freqs (map #(v->k % 5)) (apply str) println)
