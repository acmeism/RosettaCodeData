(defn knapsacks []
  (let [pan (struct item 3000 0.3 0.025)
        ich (struct item 1800 0.2 0.015)
        gol (struct item 2500 2.0 0.002)
        types [pan ich gol]
        max-w 25.0
        max-v 0.25
        iters #(range (inc (max-count % max-w max-v)))]
    (filter (complement nil?)
      (pmap
        #(let [[p i g] %
                w (total :weight types %)
                v (total :volume types %)]
          (if (and (<= w max-w) (<= v max-v))
            (with-meta (struct item (total :value types %) w v) {:p p :i i :g g})))
        (for [p (iters pan)
              i (iters ich)
              g (iters gol)]
          [p i g])))))
