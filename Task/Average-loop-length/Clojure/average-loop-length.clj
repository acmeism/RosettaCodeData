(ns cyclelengths
  (:gen-class))

(defn factorial [n]
  " n! "
  (apply *' (range 1 (inc n))))             ; Use *' (vs. *) to allow arbitrary length arithmetic

(defn pow [n i]
  " n^i"
  (apply *' (repeat i n)))

(defn analytical [n]
  " Analytical Computation "
  (->>(range 1 (inc n))
      (map #(/ (factorial n) (pow n %) (factorial (- n %)))) ;calc n %))
      (reduce + 0)))

;; Number of random times to test each n
(def TIMES 1000000)

(defn single-test-cycle-length [n]
  " Single random test of cycle length "
  (loop [count 0
         bits 0
         x 1]
    (if (zero? (bit-and x bits))
      (recur (inc count) (bit-or bits x) (bit-shift-left 1 (rand-int n)))
        count)))

(defn avg-cycle-length [n times]
  " Average results of single tests of cycle lengths "
  (/
   (reduce +
           (for [i (range times)]
             (single-test-cycle-length n)))
  times))

;; Show Results
(println "\tAvg\t\tExp\t\tDiff")
(doseq [q (range 1 21)
        :let [anal (double (analytical q))
              avg (double (avg-cycle-length q TIMES))
              diff (Math/abs (* 100 (- 1 (/ avg anal))))]]
  (println (format "%3d\t%.4f\t%.4f\t%.2f%%" q avg anal diff)))
