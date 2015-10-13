(defn nine-billion-names [row column]
  (cond (<= row 0) 0
        (<= column 0) 0
        (< row column) 0
        (= row 1) 1
        :else (let [addend (nine-billion-names (dec row) (dec column))
                    augend (nine-billion-names (- row column) column)]
	            (+ addend augend))))

(defn print-row [row]
  (doseq [x (range 1 (inc row))]
    (print (nine-billion-names row x) \space))
    (println))

(defn print-triangle [rows]
  (doseq [x (range 1 (inc rows))]
    (print-row x)))

(print-triangle 25)
