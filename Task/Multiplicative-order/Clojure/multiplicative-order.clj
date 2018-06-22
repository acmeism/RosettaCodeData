(defn gcd [a b]
   (if (zero? b)
      a
      (recur b (mod a b))))

(defn lcm [a b]
   (/ (* a b) (gcd a b)))

(def NaN  (Math/log -1))

(defn ord' [a [p e]]
   (let [m   (imath/expt p e)
         t   (* (quot m p) (dec p))]
            (loop [dv (factor/divisors t)]
               (let [d (first dv)]
                  (if (= (mmath/expm a d m) 1)
                     d
                     (recur (next dv)))))))

(defn ord [a n]
   (if (not= (gcd a n) 1)
      NaN
      (->>
         (factor/factorize n)
         (map (partial ord' a))
         (reduce lcm))))
