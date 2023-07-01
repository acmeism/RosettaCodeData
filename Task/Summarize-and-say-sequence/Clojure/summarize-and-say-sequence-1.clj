(defmacro reduce-with
  "simplifies form of reduce calls"
  [bindings & body]
  (assert (and (vector? bindings) (= 4 (count bindings))))
  (let [[acc init, item sequence] bindings]
    `(reduce (fn [~acc ~item] ~@body) ~init ~sequence)))

(defn digits
  "maps e.g. 2345 => [2 3 4 5]"
  [n] (->> n str seq (map #(- (int %) (int \0))) vec))

(defn dcount
  "handles case (probably impossible in this range) of digit count > 9"
  [ds] (let [c (count ds)] (if (< c 10) c (digits c))))

(defn summarize-prev
  "produces the summary sequence for a digit sequence"
  [ds]
  (->> ds (sort >) (partition-by identity) (map (juxt dcount first)) flatten vec)

(defn convergent-sequence
  "iterates summarize-prev until a duplicate is found; returns summary step sequence"
  [ds]
  (reduce-with [cur-seq [], ds (iterate summarize-prev ds)]
    (if (some #{ds} cur-seq)
      (reduced cur-seq)
      (conj cur-seq ds))))

(defn candidate-seq
  "only try an already sorted digit sequence, so we only try equivalent seeds once;
   e.g. 23 => []; 32 => (convergent-sequence [3 2])"
  [n]
  (let [ds (digits n)]
    (if (apply >= ds) (convergent-sequence ds) [])))

(defn find-longest
  "the meat of the task; returns summary step sequence(s) of max length within the range"
  [limit]
  (reduce-with [max-seqs [[]], new-seq (map candidate-seq (range 1 limit))]
    (let [cmp (compare (-> max-seqs first count) (count new-seq))]
      (cond
        (pos? cmp) max-seqs
        (neg? cmp) [new-seq]
        (zero? cmp) (conj max-seqs new-seq)))))

(def results (find-longest 1000000))
