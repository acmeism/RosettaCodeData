(ns async-example.core
  (:use [criterium.core])
  (:gen-class))

; Java Arbitray Precision Library
(import '(org.apfloat Apfloat ApfloatMath))

(def precision 8192)

; Define big constants (i.e. 1, 2, 4, 0.5, .25, 1/sqrt(2))
(def one (Apfloat. 1M precision))
(def two (Apfloat. 2M precision))
(def four (Apfloat. 4M precision))
(def half (Apfloat. 0.5M precision))
(def quarter (Apfloat. 0.25M precision))
(def isqrt2 (.divide one  (ApfloatMath/pow two half)))

(defn compute-pi [iterations]
    (loop [i 0, n one, [a g] [one isqrt2], z quarter]
        (if (> i iterations)
          (.divide (.multiply a a) z)
          (let [x [(.multiply (.add a g) half) (ApfloatMath/pow (.multiply a g) half)]
                v (.subtract (first x) a)]
            (recur (inc i) (.add n n) x (.subtract z (.multiply (.multiply v v) n)))))))

(doseq [q (partition-all 200 (str (compute-pi 18)))]
    (println (apply str q)))
