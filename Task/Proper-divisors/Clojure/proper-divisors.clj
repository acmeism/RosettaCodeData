(ns properdivisors
  (:gen-class))

(defn proper-divisors [n]
  " Proper divisors of n"
  (if (= n 1)
    []
  (filter #(= 0 (rem n %)) (range 1 n))))

;; Property divisors of numbers 1 to 20,000 inclusive
(def data (for [n (range 1 (inc 20000))]
            [n (proper-divisors n)]))

;; Find Max
(defn maximal-key [k x & xs]
  " Normal max-key only finds one key that produces maximum, while this function finds them all "
  (reduce (fn [ys x]
            (let [c (compare (k x) (k (peek ys)))]
              (cond
                (pos? c) [x]
                (neg? c) ys
                :else    (conj ys x))))
          [x]
          xs))

(println "n\tcnt\tPROPER DIVISORS")
(doseq [n (range 1 11)]
  (let [factors (proper-divisors n)]
    (println n "\t" (count factors) "\t" factors)))

(def max-data (apply maximal-key (fn [[i pd]] (count pd)) data))

(doseq [[n factors] max-data]
  (println n " has " (count factors) " divisors"))
