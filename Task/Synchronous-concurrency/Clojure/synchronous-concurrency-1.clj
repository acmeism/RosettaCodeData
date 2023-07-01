(use '[clojure.java.io :as io])

(def writer (agent 0))

(defn write-line [state line]
  (println line)
  (inc state))
