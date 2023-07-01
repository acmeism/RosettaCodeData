(ns rosettacode.arithmetic.cmplx
  (:require [clojure.algo.generic.arithmetic :as ga])
  (:import [java.lang Number]))

(defrecord Complex [^Number r ^Number i]
  Object
  (toString [{:keys [r i]}]
    (apply str
      (cond
        (zero? r) [(if (= i 1) "" i) "i"]
        (zero? i) [r]
        :else     [r (if (neg? i) "-" "+") i "i"]))))

(defmethod ga/+ [Complex Complex]
  [x y] (map->Complex (merge-with + x y)))

(defmethod ga/+ [Complex Number] ; reals become y + 0i
  [{:keys [r i]} y] (->Complex (+ r y) i))

(defmethod ga/- Complex
  [x] (->> x vals (map -) (apply ->Complex)))

(defmethod ga/* [Complex Complex]
  [x y] (map->Complex (merge-with * x y)))

(defmethod ga/* [Complex Number]
  [{:keys [r i]} y] (->Complex (* r y) (* i y)))

(ga/defmethod* ga / Complex
  [x] (->> x vals (map /) (apply ->Complex)))

(defn conj [^Complex {:keys [r i]}]
  (->Complex r (- i)))

(defn inv [^Complex {:keys [r i]}]
  (let [m (+ (* r r) (* i i))]
    (->Complex (/ r m) (- (/ i m)))))
