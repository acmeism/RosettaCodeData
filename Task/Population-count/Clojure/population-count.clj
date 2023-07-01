(defn population-count [n]
  (Long/bitCount n))         ; use Java inter-op

(defn exp [n pow]
  (reduce * (repeat pow n)))

(defn evil? [n]
  (even? (population-count n)))

(defn odious? [n]
  (odd? (population-count n)))

;;
;; Clojure's support for generating "lazily-evaluated" infinite sequences can
;; be used to generate the requested output sets.  We'll create some infinite
;; sequences, and only as many items will be computed as are "pulled" by 'take'.
;;
(defn integers []
  (iterate inc 0))

(defn powers-of-n [n]
  (map #(exp n %) (integers)))

(defn evil-numbers []
  (filter evil? (integers)))

(defn odious-numbers []
  (filter odious? (integers)))
