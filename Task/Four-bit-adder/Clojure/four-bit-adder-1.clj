(ns rosettacode.adder
  (:use clojure.test))

(defn xor-gate [a b]
  (or (and a (not b)) (and b (not a))))

(defn half-adder [a b]
  "output: (S C)"
  (cons (xor-gate a b) (list (and a b))))

(defn full-adder [a b c]
  "output: (C S)"
  (let [HA-ca (half-adder c a)
        HA-ca->sb (half-adder (first HA-ca) b)]
    (cons (or (second HA-ca) (second HA-ca->sb))
          (list (first HA-ca->sb)))))

(defn n-bit-adder
  "first bits on the list are low order bits
1 = true
2 = false true
3 = true true
4 = false false true..."
  can add numbers of different bit-length
  ([a-bits b-bits] (n-bit-adder a-bits b-bits false))
  ([a-bits b-bits carry]
  (let [added (full-adder (first a-bits) (first b-bits) carry)]
    (if(and (nil? a-bits) (nil? b-bits))
      (if carry (list carry) '())
      (cons (second added) (n-bit-adder (next a-bits) (next b-bits) (first added)))))))

;use:
(n-bit-adder [true true true true true true] [true true true true true true])
=> (false true true true true true true)
