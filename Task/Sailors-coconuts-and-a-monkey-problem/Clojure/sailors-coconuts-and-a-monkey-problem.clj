(defn solves-for? [sailors initial-coconut-count]
  (with-local-vars [coconuts initial-coconut-count, hidings 0]
    (while (and (> @coconuts sailors) (= (mod @coconuts sailors) 1)
      (var-set coconuts (/ (* (dec @coconuts) (dec sailors)) sailors))
      (var-set hidings (inc @hidings)))
    (and (zero? (mod @coconuts sailors)) (= @hidings sailors))))

(doseq [sailors (range 5 7)]
  (let [start (first (filter (partial solves-for? sailors) (range)))]
    (println (str sailors " sailors start with " start " coconuts:"))
    (with-local-vars [coconuts start]
      (doseq [sailor (range sailors)]
        (let [hidden (/ (dec @coconuts) sailors)]
          (var-set coconuts (/ (* (dec @coconuts) (dec sailors)) sailors))
          (println (str "\tSailor " (inc sailor) " hides " hidden " coconuts and gives 1 to the monkey, leaving " @coconuts "."))))
      (println
        (str "\tIn the morning, each sailor gets another " (/ @coconuts sailors) " coconuts."))
      (println "\tThe monkey gets no more.\n"))))
