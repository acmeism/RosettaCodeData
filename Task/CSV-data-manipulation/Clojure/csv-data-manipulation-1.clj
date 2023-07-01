(require '[clojure.data.csv :as csv]
         '[clojure.java.io :as io])

(defn add-sum-column [coll]
  (let [titles (first coll)
        values (rest coll)]
    (cons (conj titles "SUM")
      (map #(conj % (reduce + (map read-string %))) values))))

(with-open [in-file (io/reader "test_in.csv")]
  (doall
    (let [out-data (add-sum-column (csv/read-csv in-file))]
      (with-open [out-file (io/writer "test_out.csv")]
        (csv/write-csv out-file out-data)))))
