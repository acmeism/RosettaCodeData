ns test-project-intellij.core
  (:gen-class)
  (:require [clojure.string :as string]))

(def primes
" The following routine produces a infinite sequence of primes
  (i.e. can be infinite since the evaluation is lazy in that it
  only produces values as needed).  The method is from clojure primes.clj library
  which produces primes based upon O'Neill's paper:
  'The Genuine Sieve of Eratosthenes'.

   Produces primes based upon trial division on previously found primes up to
   (sqrt number), and uses 'wheel' to avoid
   testing numbers which are divisors of 2, 3, 5, or 7.
   A full explanation of the method is available at:
   [https://github.com/stuarthalloway/programming-clojure/pull/12] "

  (concat
    [2 3 5 7]
    (lazy-seq
      (let [primes-from   ; generates primes by only checking if primes
                          ; numbers which are not divisible by 2, 3, 5, or 7
            (fn primes-from [n [f & r]]
              (if (some #(zero? (rem n %))
                        (take-while #(<= (* % %) n) primes))
                (recur (+ n f) r)
                (lazy-seq (cons n (primes-from (+ n f) r)))))

            ; wheel provides offsets from previous number to insure we are not landing on a divisor of 2, 3, 5, 7
            wheel (cycle [2 4 2 4 6 2 6 4 2 4 6 6 2 6  4  2
                          6 4 6 8 4 2 4 2 4 8 6 4 6 2  4  6
                          2 6 6 4 2 4 6 2 6 4 2 4 2 10 2 10])]
        (primes-from 11 wheel)))))

(defn between [lo hi]
  "Primes between lo and hi value "
  (->> (take-while #(<= % hi) primes)
       (filter #(>= % lo))
       ))
	
(println "First twenty:" (take 20 primes))

(println "Between 100 and 150:" (between 100 150))

(println "Number between 7,7700 and 8,000:" (count (between 7700 8000)))

(println "10,000th prime:" (nth primes (dec 10000)))    ; decrement by one since nth starts counting from 0


}
