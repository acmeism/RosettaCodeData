(import '(java.io File))

(defn kind [filename]
  (let [f (File. filename)]
    (cond
      (.isFile f)      "file"
      (.isDirectory f) "directory"
      (.exists f)      "other"
      :else            "(non-existent)" )))

(defn look-for [filename]
  (println filename ":" (kind filename)))

(look-for "input.txt")
(look-for "/input.txt")
(look-for "docs")
(look-for "/docs")
