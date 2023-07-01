(ns test-project-intellij.core
  (:gen-class))

(defn cube [x]
  "Cube a number through triple multiplication"
  (* x x x))

(defn sum3 [[i j]]
   " [i j] -> i^3 + j^3"
  (+ (cube i) (cube j)))

(defn next-pair [[i j]]
  " Generate next [i j] pair of sequence  (producing lower triangle pairs) "
  (if (< j i)
    [i (inc j)]
    [(inc i) 1]))

;; Pair sequence generator [1 1] [2 1] [2 2] [3 1] [3 2] [3 3] ...
(def pairs-seq	(iterate next-pair [1 1]))

(defn dict-inc [m pair]
  " Add pair to pair map m, with the key of the map based upon the cubic sum (sum3) and the value appends the pair "
  (update-in m [(sum3 pair)] (fnil #(conj % pair) [])))

(defn enough? [m n-to-generate]
  " Checks if we have enough taxi numbers (i.e. if number in map >= count-needed "
  (->> m                                ; hash-map of sum of cube of numbers [key] and their pairs as value
       (filter #(if (> (count (second %)) 1) true false))   ; filter out ones which don't have more than 1 entry
       (count)                                              ; count the item remaining
       (<= n-to-generate)))                                ; true iff count-needed is less or equal to the nubmer filtered

(defn find-taxi-numbers [n-to-generate]
  " Generates 1st n-to-generate taxi numbers"
  (loop [m {}               ; Hash-map containing cube of pairs (key) and set of pairs that produce sum (value)
         p pairs-seq        ; select pairs from our pair sequence generator (i.e. [1 1] [2 1] [2 2] ...)
         num-tried 0        ; Since its expensve to count how many taxi numbers we have found
         check-after 1]     ; we only check if we have enough numbers every time (num-tried equals check-after)
                            ; num-tried increments by 1 each time we try the next pair and
                            ; check-after doubles if we don't have enough taxi numbers
    (if (and (= num-tried check-after) (enough? m n-to-generate)) ; check if we found enough taxi numbers
      (sort-by first (into [] (filter #(> (count (second %)) 1) m)))  ; sort the taxi numbers and this is the result
      (if (= num-tried check-after)                                   ; Check if we need to increase our count between checking
        (recur (dict-inc m (first p)) (rest p) (inc num-tried) (* 2 check-after))   ; increased count between checking
        (recur (dict-inc m (first p)) (rest p) (inc num-tried) check-after)))))     ; didn't increase the count

; Generate 1st 2006 taxi numbers
(def result (find-taxi-numbers 2006))

;; Show First 25
(defn show-result [n sample]
  " Prints one line of result "
  (print (format "%4d:%10d" n  (first sample)))
  (doseq [q  (second sample)
          :let [[i j] q]]
      (print (format " = %4d^3 + %4d^3" i j)))
  (println))

; 1st 25 taxi numbers
(doseq [n (range 1 26)
        :let [sample (nth result (dec n))]]
  (show-result n sample))

; taxi numbers from 2000th to 2006th
(doseq [n (range 2000 2007)
        :let [sample (nth result (dec n))]]
  (show-result n sample))

}
