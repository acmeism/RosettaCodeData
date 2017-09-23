(ns test-p.core
  (:require [clojure.math.numeric-tower :as math]))

(defn prime? [a]
  " Uses trial division to determine if number is prime "
  (or (= a 2)
      (and (> a 2)
           (> (mod a 2) 0)
           (not (some #(= 0 (mod a %))
                  (range 3 (inc (int (Math/ceil (math/sqrt a)))) 2))))))
                       ; 3 to sqrt(a) stepping by 2

(defn primes-below [n]
  " Finds primes below number n "
  (for  [a (range 2 (inc n))
         :when (prime? a)]
        a))

(println (primes-below 100))
