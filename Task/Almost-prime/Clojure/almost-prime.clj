(ns clojure.examples.almostprime
	(:gen-class))

(defn divisors [n]
    " Finds divisors by looping through integers 2, 3,...i.. up to sqrt (n) [note: rather than compute sqrt(), test with i*i <=n] "
    (let [div (some #(if (= 0 (mod n %)) % nil) (take-while #(<= (* % %) n) (iterate inc 2)))]
        (if div                                                         ; div = nil (if no divisor found else its the divisor)
            (into [] (concat (divisors div) (divisors (/ n div))))      ; Concat the two divisors of the two divisors
            [n])))                                                      ; Number is prime so only itself as a divisor

(defn divisors-k [k n]
    " Finds n numbers with k divisors.  Does this by looping through integers 2, 3, ... filtering (passing) ones with k divisors and
      taking the first n "
    (->> (iterate inc 2)            ; infinite sequence of numbers starting at 2
         (map divisors)             ; compute divisor of each element of sequence
         (filter #(= (count %) k))  ; filter to take only elements with k divisors
         (take n)                   ; take n elements from filtered sequence
         (map #(apply * %))))       ; compute number by taking product of divisors

(println (for [k (range 1 6)]
          (println "k:" k (divisors-k k 10))))
