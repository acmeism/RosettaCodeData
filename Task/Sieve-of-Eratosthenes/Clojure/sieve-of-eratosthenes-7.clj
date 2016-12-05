(set! *unchecked-math* true)

(defn primes-to
  "Computes lazy sequence of prime numbers up to a given number using sieve of Eratosthenes"
  [n]
  (let [root (-> n Math/sqrt long),
        rootndx (long (/ (- root 3) 2)),
        ndx (long (/ (- n 3) 2)),
        cmpsts (long-array (inc (/ ndx 64))),
        isprm #(zero? (bit-and (aget cmpsts (bit-shift-right % 6))
                               (bit-shift-left 1 (bit-and % 63)))),
        cullp (fn [i]
                (let [p (long (+ i i 3))]
	                (loop [i (bit-shift-right (- (* p p) 3) 1)]
	                  (if (<= i ndx)
	                    (do (let [w (bit-shift-right i 6)]
	                    (aset cmpsts w (bit-or (aget cmpsts w)
	                                           (bit-shift-left 1 (bit-and i 63)))))
	                        (recur (+ i p))))))),
        cull (fn [] (loop [i 0] (if (<= i rootndx)
                                  (do (if (isprm i) (cullp i)) (recur (inc i))))))]
    (letfn [(nxtprm [i] (if (<= i ndx)
                          (cons (+ i i 3) (lazy-seq (nxtprm (loop [i (inc i)]
                                                              (if (or (> i ndx) (isprm i)) i
                                                                (recur (inc i)))))))))]
      (if (< n 2) nil
        (cons 3 (if (< n 3) nil (do (cull) (lazy-seq (nxtprm 0)))))))))
