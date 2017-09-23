(import java.nio.file.FileSystems)

(defn match-files [f pattern]
  (.matches (.getPathMatcher (FileSystems/getDefault) (str "glob:*" pattern)) (.toPath f)))

(defn walk-directory [dir pattern]
  (let [directory (clojure.java.io/file dir)]
    (map #(.getPath %) (filter #(match-files % pattern) (.listFiles directory)))))
