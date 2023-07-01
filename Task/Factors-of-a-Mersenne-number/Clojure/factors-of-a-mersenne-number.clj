(ns mersennenumber
  (:gen-class))

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

(defn divides? [k n]
  " checks if k divides n "
  (= (rem n k) 0))

(defn is-prime? [n]
  " checks if n is prime "
  (cond
    (< n 2) false             ; 0, 1 not prime (i.e. primes are greater than one)
    (= n 2) true              ; 2 is prime
    (= 0 (mod n 2)) false     ; all other evens are not prime
    :else                     ; check for divisors up to sqrt(n)
      (empty? (filter #(divides? % n) (take-while #(<= (* % %) n) (range 2 n))))))

;; Max k to check
(def MAX-K 16384)

(defn trial-factor  [p k]
  " check if k satisfies 2*k*P + 1 divides 2^p - 1 "
  (let [q  (+ (* 2 p k) 1)
        mq (mod q 8)]
    (cond
      (not (is-prime? q))     nil
      (and (not= 1 mq)
           (not= 7 mq))       nil
      (= 1 (power 2 p q))     q
      :else                   nil)))

(defn m-factor [p]
  " searches for k-factor "
  (some #(trial-factor p %) (range 16384)))

(defn -main [p]
  (if-not (is-prime? p)
    (format "M%d = 2^%d - 1 exponent is not prime" p p)
    (if-let [factor (m-factor p)]
      (format "M%d = 2^%d - 1 is composite with factor %d" p p factor)
      (format "M%d = 2^%d - 1 is prime" p p))))

;; Tests different p values
(doseq [p [2,3,4,5,7,11,13,17,19,23,29,31,37,41,43,47,53,929]
        :let [s (-main p)]]
  (println s))
