(defn ps*
  ([ps0 ps1] (ps* [0] ps0 ps1))
  ([[a0 & resta] [p0 & rest0] [p1 & rest1 :as ps1]]
    (lazy-seq
      (cons
        (+ a0 (* p0 p1))
        (let [mrest1 (if (or (nil? rest1) (zero? p0)) nil, (map #(* p0 %) rest1))
              accum  (cond (nil? resta) mrest1, (nil? mrest1) resta, :else (ps+ resta mrest1))]
          (if (nil? rest0) accum, (ps* (or accum [0]) rest0 ps1)))))))
