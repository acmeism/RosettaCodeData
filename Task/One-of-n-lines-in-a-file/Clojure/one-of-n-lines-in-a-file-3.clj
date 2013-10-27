(require '[clojure.java.io :as io])

(defn rand-line [filename]
  (with-open [reader (io/reader filename)]
    (rand-seq-elem (line-seq reader)))
