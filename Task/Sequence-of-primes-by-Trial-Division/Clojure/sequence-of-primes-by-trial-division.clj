(ns test-p.core
  (:require [clojure.math.numeric-tower :as math]))

(defn prime? [a]
  " Uses trial division to determine if number is prime "
  (not (or (< a 2)
           (some #(= 0 (mod a %))
                  (range 3 (inc (int (Math/ceil (math/sqrt a)))) 2))))) ; 3 to sqrt(n) stepping by 2

(defn primes-below [n]
  " Finds primes below number n "
  (for  [q (range 2 (inc n))
         :when (prime? q)]
        q))

(println (primes-below 100))
