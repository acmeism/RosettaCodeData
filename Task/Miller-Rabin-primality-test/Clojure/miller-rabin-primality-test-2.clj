(ns test-p.core
  (:require [clojure.math.numeric-tower :as math]))

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

(defn find-d-s [n]
" write n − 1 as 2s·d with d odd "
(loop [d (dec n), s 0]
  (if (odd? d)
    [d s]
    (recur (quot d 2) (inc s)))))

;; Deterministic Test
(defn individual-deterministic-test [a d n s]
  " Deterministic Primality Test "
  (let [z (power a d n)]
    (if (= z 1)
      WITNESSLOOP
      (loop [x z, r s]
        (cond
          (= x (dec n)) WITNESSLOOP
          (zero? r) COMPOSITE
          :else (recur (power x 2 n) (dec r)))))))

(defn deterministic-test [n]
  " Sequence of Primality Tests "
  (cond
    (some #{n} [0 1 4]) false
    (some #{n} [2 3]) true
    (even? n) false
    :else (let [[d s] (find-d-s n)]
            (cond
              (< n 2047) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s)) [2 ])
              (< n 1373653) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s))  [2 3])
              (< n 9090191) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s))  [31 73])
              (< n 25326001) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s))  [2 3 5])
              (< n 3215031751) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s))  [2 3 5 7])
              (< n 1122004669633) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s))  [2 13 23 1662803])
              (< n 2152302898747) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s))  [2 3 5 7 11])
              (< n 2152302898747) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s))  [2 3 5 7 11])
              (< n 3474749660383) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s))  [2 3 5 7 11 13])
              (< n 341550071728321) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s))  [2 3 5 7 11 13 17])
              (< n 3825123056546,413,051) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s)) [2 3 5 7 11 13 17 19 23])
              (< n (math/expt 2 64) ) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s)) [2 3 5 7 11 13 17 19 23 29 31 37])
              (< n 318665857834031151167461) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s)) [2 3 5 7 11 13 17 19 23 29 31 37])
              (< n 3317044064679887385961981) (not-any? #(= COMPOSITE (individual-deterministic-test % d n s)) [2 3 5 7 11 13 17 19 23 29 31 37 41])
              :else (let [k (min (dec n) (int (math/expt (Math/log n) 2)))]
                      (not-any? #(= COMPOSITE (individual-deterministic-test % d n s)) (range 2 (inc k))))))))


;; Testing
(println "Primes beteen 900-1000:")
(doseq [q (range 900 1000)
        :when (deterministic-test q)]
  (print " " q))
(println)
(println "Is Prime?" 4547337172376300111955330758342147474062293202868155909489 (deterministic-test 4547337172376300111955330758342147474062293202868155909489))
(println "Is Prime?" 4547337172376300111955330758342147474062293202868155909393 (deterministic-test 4547337172376300111955330758342147474062293202868155909393))
println "Is Prime?" 643808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153
         (deterministic-test 643808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153))

(println "Is Prime?" 743808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153
         (deterministic-test 743808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153))
(println "Is Prime?" 643808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153
         (deterministic-test 643808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153))

(println "Is Prime?" 743808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153
         (deterministic-test 743808006803554439230129854961492699151386107534013432918073439524138264842370630061369715394739134090922937332590384720397133335969549256322620979036686633213903952966175107096769180017646161851573147596390153))
