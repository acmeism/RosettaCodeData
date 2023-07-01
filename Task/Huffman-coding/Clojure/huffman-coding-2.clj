(require '[clojure.data.priority-map :refer [priority-map-keyfn-by]])
(require '[clojure.pprint :refer [print-table]])

(defn init-pq [s]
  (let [c (count s)]
    (->> s frequencies
	(map (fn [[k v]] [k {:sym k :weight (/ v c)}]))
	(into (priority-map-keyfn-by :weight <)))))

(defn huffman-tree [pq]
  (letfn [(build-step
	   [pq]
	   (let [a (second (peek pq)) b (second (peek (pop pq)))
		 nn {:sym (str (:sym a) (:sym b))
		     :weight (+ (:weight a) (:weight b))
		     :left a :right b}]
	     (assoc (pop (pop pq)) (:sym nn) nn)))]
    (->> (iterate build-step pq)
	 (drop-while #(> (count %) 1))
	 first vals first)))

(defn symbol-map [m]
  (letfn [(sym-step
	   [{:keys [sym weight left right] :as m} code]
	   (cond (and left right) #(vector (trampoline sym-step left (str code \0))
					   (trampoline sym-step right (str code \1)))
		 left #(sym-step left (str code \0))
		 right #(sym-step right (str code \1))
		 :else {:sym sym :weight weight :code code}))]
    (trampoline sym-step m "")))

(defn huffman-encode [s]
  (->> s init-pq huffman-tree symbol-map flatten))

(defn display-huffman-encode [s]
  (->> s huffman-encode (sort-by :weight >) print-table))

(display-huffman-encode "this is an example for huffman encoding")
