(ns test-p.core)
(defn gcd
  "(gcd a b) computes the greatest common divisor of a and b."
  [a b]
  (if (zero? b)
    a
    (recur b (mod a b))))

(defn stern-brocat-next [p]
  " p is the block of the sequence we are using to compute the next block
    This routine computes the next block "
  (into [] (concat (rest p) [(+ (first p) (second p))] [(second p)])))

(defn seq-stern-brocat
  ([] (seq-stern-brocat [1 1]))
  ([p] (lazy-seq (cons (first p)
                       (seq-stern-brocat (stern-brocat-next p))))))

; First 15 elements
(println (take 15 (seq-stern-brocat)))

; Where numbers 1 to 10 first appear
(doseq [n (concat (range 1 11) [100])]
  (println "The first appearnce of" n "is at index" (some (fn [[i k]] (when (= k n) (inc i)))
                 (map-indexed vector (seq-stern-brocat)))))

;; Check that gcd between 1st 1000 consecutive elements equals 1
;   Create cosecutive pairs of 1st 1000 elements
(def one-thousand-pairs (take 1000 (partition 2 1 (seq-stern-brocat))))
;   Check every pair has a gcd = 1
(println (every? (fn [[ith ith-plus-1]] (= (gcd ith ith-plus-1) 1))
               one-thousand-pairs))
