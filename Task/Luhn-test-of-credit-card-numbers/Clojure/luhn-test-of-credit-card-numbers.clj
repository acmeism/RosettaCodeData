(defn luhn? [cc]
  (let [factors (flatten (repeat [1 2]))
        numbers (map #(Character/digit % 10) (seq cc))
        sum (reduce + (map #(int (+ (/ %1 10) (mod %1 10)))
                        (map * (reverse numbers) factors)))]
    (zero? (mod sum 10))))

(doseq [n [49927398716 49927398717 1234567812345678 1234567812345670]]
  (println (luhn? n)))
