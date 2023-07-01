(def rules
 {
    [0 0 0] 0
    [0 0 1] 0
    [0 1 0] 0
    [0 1 1] 1
    [1 0 0] 0
    [1 0 1] 1
    [1 1 0] 1
    [1 1 1] 0
  })

(defn nextgen [gen]
  (concat [0]
          (->> gen
               (partition 3 1)
               (map vec)
               (map rules))
          [0]))

; Output time!
(doseq [g (take 10 (iterate nextgen [0 1 1 1 0 1 1 0 1 0 1 0 1 0 1 0 0 1 0 0]))]
  (println g))
