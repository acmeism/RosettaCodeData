(require '[clojure.java.io :as jio]
         '[clojure.string :as str])

(defn remove-lines2 [filepath start nskip]
  (with-open [rdr (jio/reader filepath)]
    (with-open [wrt (jio/writer (str filepath ".tmp"))]
      (loop [s start n nskip]
        (if-let [line (.readLine rdr)]
          (cond
            (> s 1)  (do (doto wrt (.write line) (.newLine))
                         (recur (dec s) n))
            (pos? n) (recur s (dec n))
            :else    (do (doto wrt (.write line) (.newLine))
                         (recur s n)))
          (when (pos? n)
            (println "WARN: You are trying to remove lines beyond EOF"))))))
  (.renameTo (jio/file (str filepath ".tmp")) (jio/file filepath)))
