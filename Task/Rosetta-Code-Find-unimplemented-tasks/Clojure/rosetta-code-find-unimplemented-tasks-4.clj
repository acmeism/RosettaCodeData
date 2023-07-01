(defn unimplemented [lang-name]
  (let [title-set #(future (apply sorted-set (get-titles %)))
        all-titles (title-set "Programming_Tasks")
        lang-titles (title-set lang-name)]
    (seq (set/difference @all-titles @lang-titles))))

(let [titles (unimplemented "Clojure")]
  (doseq [title titles] (println title))
  (println "count: " (count titles)))
(shutdown-agents)
