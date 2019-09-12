(def data
  [12 127 28 42 39 113 42 18 44 118 44 37 113 124 37 48 127 36 29 31 125
   139 131 115 105 132 104 123 35 113 122 42 117 119 58 109 23 105 63 27
   44 105 99 41 128 121 116 125 32 61 37 127 29 113 121 58 114 126 53 114
   96 25 109 7 31 141 46 13 27 43 117 116 27 7 68 40 31 115 124 42 128 146
   52 71 118 117 38 27 106 33 117 116 111 40 119 47 105 57 122 109 124
   115 43 120 43 27 27 18 28 48 125 107 114 34 133 45 120 30 127 31 116])

(defn calc-stem [number]
  (int (Math/floor (/ number 10))))

(defn calc-leaf [number]
  (mod number 10))

(defn new-plant
  "Returns a leafless plant, with `size` empty branches,
  i.e. a hash-map with integer keys (from 0 to `size` inclusive)
  mapped to empty vectors.

  (new-plant 2) ;=> {0 [] 1 [] 2 []}"
  [size]
  (let [end (inc size)]
    (->> (repeat end [])
         (interleave (range end))
         (apply hash-map))))

(defn sprout-leaves
  [plant [stem leaf]]
  (update plant stem conj leaf))

(defn stem-and-leaf [numbers]
  (let [max-stem   (calc-stem (reduce max numbers))
        baby-plant (new-plant max-stem)
        plant      (->> (map (juxt calc-stem calc-leaf) numbers)
                        (reduce sprout-leaves baby-plant)
                        (sort))]
    (doseq [[stem leaves] plant]
      (print   (format (str "%2s") stem))
      (print   " | ")
      (println (clojure.string/join " " (sort leaves))))))

(stem-and-leaf data)
