(ns derangements.core
  (:require [clojure.set :as s]))

(defn subfactorial [n]
  (case n
    0 1
    1 0
    (* (dec n) (+ (subfactorial (dec n)) (subfactorial (- n 2))))))

(defn no-fixed-point
  "f : A -> B must be a biyective function written as a hash-map, returns
  all g : A -> B such that (f(a) = b) => not(g(a) = b)"
  [f]
  (case (count f)
    0 [{}]
    1 []
    (let [g  (s/map-invert f)
          a  (first (keys f))
          a' (f a)]
      (mapcat
       (fn [b'] (let [b  (g b')
                      f' (dissoc f a b)]
                   (concat (map #(reduce conj % [[a b'] [b a']])
                                (no-fixed-point f'))
                           (map #(conj % [a b'])
                                (no-fixed-point (assoc f' b a'))))))
       (filter #(not= a' %) (keys g))))))

(defn derangements [xs]
  {:pre [(= (count xs) (count (set xs)))]}
  (map (fn [f] (mapv f xs))
       (no-fixed-point (into {} (map vector xs xs)))))

(defn -main []
  (do
    (doall (map println (derangements [0,1,2,3])))
    (doall (map #(println (str (subfactorial %) " " (count (derangements (range %)))))
                (range 10)))
    (println (subfactorial 20))))
