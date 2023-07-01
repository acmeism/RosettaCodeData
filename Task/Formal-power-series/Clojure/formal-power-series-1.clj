(defn ps+ [ps0 ps1]
  (letfn [(+zs   [ps] (concat ps (repeat :z)))
          (notz? [a] (not= :z a))
          (nval  [a] (if (notz? a) a 0))
          (z+    [a0 a1] (if (= :z a0 a1) :z (+ (nval a0) (nval a1))))]
    (take-while notz? (map z+ (+zs ps0) (+zs ps1)))))

(defn ps- [ps0 ps1] (ps+ ps0 (map - ps1)))
