(defn tape
  "Creates a new tape with given blank character and tape contents"
  ([blank] (tape () blank () blank))
  ([right blank] (tape () (first right) (rest right) blank))
  ([left head right blank] [(reverse left) (or head blank) (into () right) blank]))

; Tape operations
(defn- left  [[[l & ls] _ rs       b] c] [ls          (or l b) (conj rs c) b])
(defn- right [[ls       _ [r & rs] b] c] [(conj ls c) (or r b) rs          b])
(defn- stay  [[ls       _ rs       b] c] [ls          c        rs          b])
(defn- head [[_ c _ b]] (or c b))
(defn- pretty [[ls c rs b]] (concat (reverse ls) [[(or c b)]] rs))

(defn new-machine
 "Returns a function that takes a tape as input, and returns the tape
  after running the machine specified in `machine`."
  [machine]
  (let [rules (into {} (for [[s c c' a s'] (:rules machine)]
                         [[s c] [c' (-> a name symbol resolve) s']]))
        finished? (into #{} (:terminating machine))]
    (fn [input-tape]
      (loop [state (:initial machine) tape input-tape]
        (if (finished? state)
          (pretty tape)
          (let [[out action new-state] (get rules [state (head tape)])]
            (recur new-state (action tape out))))))))
