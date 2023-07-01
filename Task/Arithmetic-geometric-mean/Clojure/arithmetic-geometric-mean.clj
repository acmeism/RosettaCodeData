(ns agmcompute
  (:gen-class))

; Java Arbitray Precision Library
(import '(org.apfloat Apfloat ApfloatMath))

(def precision 70)
(def one (Apfloat. 1M precision))
(def two (Apfloat. 2M precision))
(def half (Apfloat. 0.5M precision))
(def isqrt2 (.divide one  (ApfloatMath/pow two half)))
(def TOLERANCE (Apfloat. 0.000000M precision))

(defn agm [a g]
  " Simple AGM Loop calculation "
       (let [THRESH 1e-65                 ; done when error less than threshold or we exceed max loops
             MAX-LOOPS 1000000]
        (loop [[an gn] [a g], cnt 0]
            (if (or (< (ApfloatMath/abs (.subtract an gn)) THRESH)
                    (> cnt MAX-LOOPS))
              an
              (recur [(.multiply (.add an gn) half) (ApfloatMath/pow (.multiply an gn) half)]
                     (inc cnt))))))

(println  (agm one isqrt2))
