(def DIGITS (range 0 10))

(defn -factorial [n]
  (apply * (take n (iterate inc 1))))
;   Cached version of factorial
(def factorial (memoize -factorial))

(defn -combinations [coll k]
  " From http://rosettacode.org/wiki/Combinations_with_repetitions#Clojure "
  (when-let [[x & xs] coll]
    (if (= k 1)
      (map list coll)
      (concat (map (partial cons x) (-combinations coll (dec k)))
              (-combinations xs k)))))
;   Cached version of combinations
(def combinations (memoize -combinations))

(defn comb [n r]
  " count of n items select r "
  (/ (/ (factorial n) (factorial r)) (factorial (- n r))))

(defn count-digits [digit-list]
  " count nunmber of occurences of digit in list "
  (reduce (fn [m v] (update-in m [v] (fnil inc 0))) {} digit-list))

(defn count-patterns [c]
  " Count of number of patterns with these digits "
  (->>
    c
    (count-digits)
    (reduce (fn [accum [k v]]
              (* accum (factorial v)))
            1)
    (/ (factorial (count c)))))

(defn itertools-comb [ndigits]
  (->>
    ndigits
    (combinations DIGITS)
    (filter #(is89 (sum-sqr %)))                 ; items which are not 89 (i.e. 1 since lower count)
    (reduce (fn [acc c]
              (+ acc (count-patterns c)))
            0)
    (- (math/expt 10 ndigits))))

(println (itertools-comb 8))
;; Time obtained using benchmark library (i.e. (bench (itertools-comb 8))  )
