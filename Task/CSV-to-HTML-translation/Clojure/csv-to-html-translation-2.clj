(require 'clojure.string)

(def escapes
     {\< "&lt;", \> "&gt;", \& "&amp;"})

(defn escape
      [content]
      (clojure.string/escape content escapes))

(defn tr
      [cells]
      (format "<tr>%s</tr>"
              (apply str (map #(str "<td>" (escape %) "</td>") cells))))

;; turn a seq of seq of cells into a string.
(defn to-html
      [tbl]
      (format "<table><tbody>%s</tbody></thead>"
              (apply str (map tr tbl))))

;; Read from a string to a seq of seq of cells.
(defn from-csv
      [text]
      (map #(clojure.string/split % #",")
            (clojure.string/split-lines text)))

(defn -main
      []
      (let [lines (line-seq (java.io.BufferedReader. *in*))
            tbl (map #(clojure.string/split % #",") lines)]
           (println (to-html tbl)))
