(use '[clojure.string :only [join]])

(let [[value indexes] (m (-> items count dec) 400)
      names (map (comp :name items) indexes)]
  (println "items to pack:" (join ", " names))
  (println "total value:" value)
  (println "total weight:" (reduce + (map (comp :weight items) indexes))))
