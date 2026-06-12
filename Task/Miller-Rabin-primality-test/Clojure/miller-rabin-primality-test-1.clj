(ns test-p.core
  (:require [clojure.math.numeric-tower :as math])
  (:require [clojure.set :as set]))

(def WITNESSLOOP "witness")
(def COMPOSITE "composite")

(defn m* [p q m]
  " Computes (p*q) mod m "
  (mod (*' p q) m))

(defn power
  "modular exponentiation (i.e. b^e mod m"
  [b e m]
  (loop [b b, e e, x 1]
    (if (zero? e)
      x
      (if (even? e) (recur (m* b b m) (quot e 2) x)
                    (recur (m* b b m) (quot e 2) (m* b x m))))))

; Sequence of random numbers to use in the test
(defn rand-num [n]
  " random number between 2 and n-2 "
  (bigint (math/floor (+' 2 (*' (- n 4) (rand))))))

; Unique set of random numbers
(defn unique-random-numbers [n k]
  " k unique random numbers between 2 and n-2 "
  (loop [a-set #{}]
    (cond
      (>= (count a-set) k) a-set
      :else (recur (conj a-set (rand-num n))))))

(defn find-d-s [n]
  " write n − 1 as 2s·d with d odd "
  (loop [d (dec n), s 0]
    (if (odd? d)
      [d s]
      (recur (quot d 2) (inc s)))))

(defn random-test
  ([n] (random-test n (min 1000 (bigint (/ n 2)))))
  ([n k]
  " Random version of primality test"
  (let [[d s] (find-d-s n)
        ; Individual Primality Test
        single-test (fn [a s]
                      (let [z (power a d n)]
                       (if (some #{z} [1 (dec n)])
                         WITNESSLOOP
                         (loop [x (power z 2 n), r s]
                           (cond
                             (= x 1) COMPOSITE
                             (= x (dec n)) WITNESSLOOP
                             (= r 0) COMPOSITE
                             :else (recur (power x 2 n) (dec r)))))))]
    ; Apply Test
    ;(not-any? #(= COMPOSITE (local-test % s))
    ;          (unique-random-numbers n k))))
    (not-any? #(= COMPOSITE (single-test % s)) (unique-random-numbers n k)))))

;; Testing
(println "Primes beteen 900-1000:")
(doseq [q (range 900 1000)
        :when (random-test q)]
  (print " " q))
(println)
(println "Is Prime?" 4547337172376300111955330758342147474062293202868155909489 (random-test 4547337172376300111955330758342147474062293202868155909489))
(println "Is Prime?" 4547337172376300111955330758342147474062293202868155909393 (random-test 4547337172376300111955330758342147474062293202868155909393))
(println "Is Prime?" 643808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153
         (random-test 643808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153))

(println "Is Prime?" 743808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153
         (random-test 743808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153))
