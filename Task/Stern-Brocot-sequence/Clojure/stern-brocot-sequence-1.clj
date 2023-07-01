;; each step adds two items
(defn sb-step [v]
  (let [i (quot (count v) 2)]
    (conj v (+ (v (dec i)) (v i)) (v i))))

;; A lazy, infinite sequence -- `take` what you want.
(def all-sbs (sequence (map peek) (iterate sb-step [1 1])))

;; zero-based
(defn first-appearance [n]
  (first (keep-indexed (fn [i x] (when (= x n) i)) all-sbs)))

;; inlined abs; rem is slightly faster than mod, and the same result for positive values
(defn gcd [a b]
  (loop [a (if (neg? a) (- a) a)
         b (if (neg? b) (- b) b)]
    (if (zero? b)
      a
      (recur b (rem a b)))))

(defn check-pairwise-gcd [cnt]
  (let [sbs (take (inc cnt) all-sbs)]
    (every? #(= 1 %) (map gcd sbs (rest sbs)))))

;; one-based index required by problem statement
(defn report-sb []
  (println "First 15 Stern-Brocot members:" (take 15 all-sbs))
  (println "First appearance of N at 1-based index:")
  (doseq [n [1 2 3 4 5 6 7 8 9 10 100]]
    (println " first" n "at" (inc (first-appearance n))))
  (println "Check pairwise GCDs = 1 ..." (check-pairwise-gcd 1000))
  true)

(report-sb)
