(def lowercase (map char (range (int \a) (inc (int \z)))))

(defn move-to-front [x xs]
  (cons x (remove #{x} xs)))

(defn encode [text table & {:keys [acc] :or {acc []}}]
  (let [c (first text)
        idx (.indexOf table c)]
    (if (empty? text) acc (recur (drop 1 text) (move-to-front c table) {:acc (conj acc idx)}))))

(defn decode [indices table & {:keys [acc] :or {acc []}}]
  (if (empty? indices) (apply str acc)
    (let [n (first indices)
          c (nth table n)]
      (recur (drop 1 indices) (move-to-front c table) {:acc (conj acc c)}))))

(doseq [word ["broood" "bananaaa" "hiphophiphop"]]
  (let [encoded (encode word lowercase)
        decoded (decode encoded lowercase)]
    (println (format "%s encodes to %s which decodes back to %s."
                   word encoded decoded))))
