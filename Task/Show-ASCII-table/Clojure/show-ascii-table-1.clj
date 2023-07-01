(defn cell [code]
  (let [text (get {32 "Spc", 127 "Del"} code (char code))]
    (format "%3d: %3s" code text)))

(defn ascii-table [n-cols st-code end-code]
  (let [n-cells (inc (- end-code st-code))
        n-rows  (/ n-cells n-cols)
        code    (fn [r c] (+ st-code r (* c n-rows)))
        row-str (fn [r]
                  (clojure.string/join "  "
                                       (map #(cell (code r %))
                                            (range n-cols))))]
    (->> (for [r (range n-rows)]
           (row-str r))
         (clojure.string/join "\n"))))

(defn pr-ascii-table [n-cols st-code end-code]
  (println (ascii-table n-cols st-code end-code)))
