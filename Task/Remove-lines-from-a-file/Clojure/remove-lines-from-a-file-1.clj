(require '[clojure.java.io :as jio]
         '[clojure.string :as str])

(defn remove-lines1 [filepath start nskip]
  (let [lines (str/split-lines (slurp filepath))
        new-lines (concat (take (dec start) lines)
                          (drop (+ (dec start) nskip) lines))
        diff (- (count lines) (count new-lines))]
    (when-not (zero? diff)
      (println "WARN: You are trying to remove lines beyond EOF"))
    (with-open [wrt (jio/writer (str filepath ".tmp"))]
      (.write wrt (str/join "\n" new-lines)))
    (.renameTo (jio/file (str filepath ".tmp")) (jio/file filepath))))
