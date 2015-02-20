(defn primes-to
  "Returns a list of all primes from 2 to n"
  [n]
  (let [n (int n)]
    (let [root (-> n Math/sqrt int)]
      (loop [i (int 2), a (boolean-array (inc n)), result (transient [])]
        (if (> i n)
          (persistent! result)
          (recur (inc i)
                 (if (and (<= i root) (not (aget a i)))
                   (loop [arr a, j (* i i)]
                     (if (> j n)
                       arr
                       (recur (do (aset arr j true) arr)
                              (+ j i))))
                   a)
                 (if (not (aget a i))
                   (conj! result i)
                   result)))))))
