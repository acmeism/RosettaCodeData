(defn find-first
 " Finds first element of collection that satisifies predicate function pred "
  [pred coll]
  (first (filter pred coll)))

(defn modpow
  " b^e mod m (using Java which solves some cases the pure clojure method has to be modified to tackle--i.e. with large b & e and
    calculation simplications when gcd(b, m) == 1 and gcd(e, m) == 1) "
  [b e m]
  (.modPow (biginteger b) (biginteger e) (biginteger m)))

(defn legendre [a p]
  (modpow a (quot (dec p) 2) p)
)

(defn tonelli [n p]
  " Following Wikipedia https://en.wikipedia.org/wiki/Tonelli%E2%80%93Shanks_algorithm "
  (assert (= (legendre n p) 1) "not a square (mod p)")
  (loop [q (dec p)                                                  ; Step 1 in Wikipedia
         s 0]
    (if (zero? (rem q 2))
      (recur (quot q 2) (inc s))
      (if (= s 1)
        (modpow n (quot (inc p) 4) p)
        (let [z (find-first #(= (dec p) (legendre % p)) (range 2 p))] ; Step 2 in Wikipedia
          (loop [
                 M s
                 c (modpow z q p)
                 t (modpow n q p)
                 R (modpow n (quot (inc q) 2) p)]
            (if (= t 1)
              R
              (let [i (long (find-first #(= 1 (modpow t (bit-shift-left 1 %) p)) (range 1 M))) ; Step 3
                    b (modpow c (bit-shift-left 1 (- M i 1)) p)
                    M i
                    c (modpow b 2 p)
                    t (rem (* t c) p)
                    R (rem (* R b) p)]
                (recur M c t R)
                )
              )
            )
          )
        )
      )
    )
  )


; Testing--using Python examples
(doseq [[n p]  [[10, 13], [56, 101], [1030, 10009], [44402, 100049],
                [665820697, 1000000009], [881398088036, 1000000000039],
                [41660815127637347468140745042827704103445750172002, 100000000000000000000000000000000000000000000000577]]
        :let [r (tonelli n p)]]
  (println (format "n: %5d p: %d \n\troots: %5d %5d" (biginteger n) (biginteger p) (biginteger r) (biginteger (- p r)))))
