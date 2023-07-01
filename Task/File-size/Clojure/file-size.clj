(require '[clojure.java.io :as io])
(defn show-size [filename]
  (println filename "size:" (.length (io/file filename))))

(show-size "input.txt")
(show-size "/input.txt")
