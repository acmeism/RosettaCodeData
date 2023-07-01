(ns example
  (:gen-class))

(defn prime? [n]
  " Prime number test (using Java) "
  (.isProbablePrime (biginteger n) 16))

(defn carmichael [p1]
  " Triplets of Carmichael primes, with first element prime p1 "
  (if (prime? p1)
    (into [] (for [h3 (range 2 p1)
          :let [g (+ h3 p1)]
          d (range 1 g)
          :when (and (= (mod (* g (dec p1)) d) 0)
                     (= (mod (- (* p1 p1)) h3) (mod d h3)))
          :let [p2 (inc (quot (* (dec p1) g) d))]
          :when (prime? p2)
          :let [p3 (inc (quot (* p1 p2) h3))]
          :when (prime? p3)
          :when (= (mod (* p2 p3) (dec p1)) 1)]
         [p1 p2 p3]))))

; Generate Result
(def numbers (mapcat carmichael (range 2 62)))
(println (count numbers) "Carmichael numbers found:")
(doseq [t numbers]
  (println (format "%5d x %5d x %5d = %10d" (first t) (second t) (last t) (apply * t))))
