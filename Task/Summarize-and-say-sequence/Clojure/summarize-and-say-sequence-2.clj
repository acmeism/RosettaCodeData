(defn perms
  "produce all the permutations of a finite sequence"
  [ds]
  (if (empty? ds)
    []
    (let [rotseq (for [n (range (count ds))] (concat (drop n ds) (take n ds)))]
      (reduce-with [rs [], [[d & ds]] rotseq]
        (concat rs (if (empty? ds) [[d]] (map #(cons d %) (perms ds))))))))

(doseq [result results]
  (let [seed (first result)
        seeds (->> seed perms (map vec) set sort (remove (comp zero? first)))]
    (apply println "Seed value(s):" (map #(apply str %) seeds)))))
  (println)
  (println "Iterations:" (count result))
  (println)
  (println "Sequence:")
  (doseq [ds result]
    (println (apply str ds))))
