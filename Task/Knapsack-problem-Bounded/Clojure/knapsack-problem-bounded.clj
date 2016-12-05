(ns knapsack
  (:gen-class))

(def groupeditems [
                   ["map", 9, 150, 1]
                   ["compass", 13, 35, 1]
                   ["water", 153, 200, 3]
                   ["sandwich", 50, 60, 2]
                   ["glucose", 15, 60, 2]
                   ["tin", 68, 45, 3]
                   ["banana", 27, 60, 3]
                   ["apple", 39, 40, 3]
                   ["cheese", 23, 30, 1]
                   ["beer", 52, 10, 3]
                   ["suntan cream", 11, 70, 1]
                   ["camera", 32, 30, 1]
                   ["t-shirt", 24, 15, 2]
                   ["trousers", 48, 10, 2]
                   ["umbrella", 73, 40, 1]
                   ["waterproof trousers", 42, 70, 1]
                   ["waterproof overclothes", 43, 75, 1]
                   ["note-case", 22, 80, 1]
                   ["sunglasses", 7, 20, 1]
                   ["towel", 18, 12, 2]
                   ["socks", 4, 50, 1]
                   ["book", 30, 10, 2]
                  ])

(defstruct item :name :weight :value)

(def items (->> (for [[item wt val n] groupeditems]
                   (repeat n [item wt val]))
                 (mapcat identity)
                 (map #(apply struct item %))
                 (vec)))

(declare mm) ;forward decl for memoization function
(defn m [i w]
  (cond
    (< i 0) [0 []]
    (= w 0) [0 []]
    :else
    (let [{wi :weight vi :value} (get items i)]
      (if (> wi w)
        (mm (dec i) w)
        (let [[vn sn :as no]  (mm (dec i) w)
              [vy sy :as yes] (mm (dec i) (- w wi))]
          (if (> (+ vy vi) vn)
            [(+ vy vi) (conj sy i)]
            no))))))

(def mm (memoize m))

(let [[value indexes] (mm (-> items count dec) 400)
      names (map (comp :name items) indexes)]
  (println "Items to pack:")
  (doseq [[k v] (frequencies names)]
    (println (format "%d %s" v k)))
  (println "Total value:" value)
  (println "Total weight:" (reduce + (map (comp :weight items) indexes))))
