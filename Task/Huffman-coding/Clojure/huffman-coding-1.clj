(require '[clojure.pprint :refer :all])

(defn probs [s]
  (let [freqs (frequencies s) sum (apply + (vals freqs))]
    (into {} (map (fn [[k v]] [k (/ v sum)]) freqs))))

(defn init-pq [weighted-items]
  (let [comp (proxy [java.util.Comparator] []
                (compare [a b] (compare (:priority a) (:priority b))))
        pq (java.util.PriorityQueue. (count weighted-items) comp)]
    (doseq [[item prob] weighted-items] (.add pq { :symbol item, :priority prob }))
    pq))

(defn huffman-tree [pq]
  (while (> (.size pq) 1)
    (let [a (.poll pq) b (.poll pq)
	  new-node {:priority (+ (:priority a) (:priority b)) :left a :right b}]
      (.add pq new-node)))
  (.poll pq))

(defn symbol-map
  ([t] (symbol-map t ""))
  ([{:keys [symbol priority left right] :as t} code]
    (if symbol [{:symbol symbol :weight priority :code code}]
      (concat (symbol-map left (str code \0))
              (symbol-map right (str code \1))))))

(defn huffman-encode [items]
  (-> items probs init-pq huffman-tree symbol-map))

(defn display-huffman-encode [s]
  (->> s huffman-encode (sort-by :weight >) print-table))

(display-huffman-encode "this is an example for huffman encoding")
