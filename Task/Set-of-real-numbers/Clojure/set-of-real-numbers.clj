(ns rosettacode.real-set)

(defn >=|<= [lo hi] #(<= lo % hi))

(defn >|< [lo hi] #(< lo % hi))

(defn >=|< [lo hi] #(and (<= lo %) (< % hi)))

(defn >|<= [lo hi] #(and (< lo %) (<= % hi)))

(def ⋃ some-fn)
(def ⋂ every-pred)
(defn ∖
  ([s1] s1)
  ([s1 s2]
     #(and (s1 %) (not (s2 %))))
  ([s1 s2 s3]
     #(and (s1 %) (not (s2 %)) (not (s3 %))))
  ([s1 s2 s3 & ss]
     (fn [x] (every? #(not (% x)) (list* s1 s2 s3 ss)))))

(clojure.pprint/pprint
  (map #(map % [0 1 2])
          [(⋃ (>|<= 0 1) (>=|< 0 2))
           (⋂ (>=|< 0 2) (>|<= 1 2))
           (∖ (>=|< 0 3) (>|< 0 1))
           (∖ (>=|< 0 3) (>=|<= 0 1))])

(def ∅ (constantly false))
(def R (constantly true))
(def Z integer?)
(def Q ratio?)
(def I #(∖ R Z Q))
(def N #(∖ Z neg?))
