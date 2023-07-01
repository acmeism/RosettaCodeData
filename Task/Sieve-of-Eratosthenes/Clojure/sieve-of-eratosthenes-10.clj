(defn primes-tox
  "Computes lazy sequence of prime numbers up to a given number using sieve of Eratosthenes"
  [n]
  (let [root (-> n Math/sqrt long),
        rootndx (long (/ (- root 3) 2)),
        ndx (max (long (/ (- n 3) 2)) 0),
        lmt (quot ndx 64),
        cmpsts (long-array (inc lmt)),
        cullp (fn [i]
                (let [p (long (+ i i 3))]
	                (loop [i (bit-shift-right (- (* p p) 3) 1)]
	                  (if (<= i ndx)
	                    (do (let [w (bit-shift-right i 6)]
                            (aset cmpsts w (bit-or (aget cmpsts w)
                                                   (bit-shift-left 1 (bit-and i 63)))))
                          (recur (+ i p))))))),
        cull (fn [] (do (aset cmpsts lmt (bit-or (aget cmpsts lmt)
                                                 (bit-shift-left -2 (bit-and ndx 63))))
                        (loop [i 0]
                          (when (<= i rootndx)
                            (when (zero? (bit-and (aget cmpsts (bit-shift-right i 6))
                                                   (bit-shift-left 1 (bit-and i 63))))
                              (cullp i))
                            (recur (inc i))))))
        numprms (fn []
                  (let [w (dec (alength cmpsts))] ;; fast results count bit counter
                    (loop [i 0, cnt (bit-shift-left (alength cmpsts) 6)]
                      (if (> i w) cnt
                        (recur (inc i)
                               (- cnt (java.lang.Long/bitCount (aget cmpsts i))))))))]
    (if (< n 2) nil
      (cons 2 (if (< n 3) nil
                (do (cull)
                    (deftype OPSeq [^long i ^longs cmpsa ^long cnt ^long tcnt] ;; for arrays maybe need to embed the array so that it doesn't get garbage collected???
                      clojure.lang.ISeq
                        (first [_] (if (nil? cmpsa) nil (+ i i 3)))
                        (next [_] (let [ncnt (inc cnt)] (if (>= ncnt tcnt) nil
                                                          (OPSeq.
                                                            (loop [j (inc i)]
                                                              (let [p? (zero? (bit-and (aget cmpsa (bit-shift-right j 6))
                                                                                       (bit-shift-left 1 (bit-and j 63))))]
                                                                (if p? j (recur (inc j)))))
                                                            cmpsa ncnt tcnt))))
                        (more [this] (let [ncnt (inc cnt)] (if (>= ncnt tcnt) (OPSeq. 0 nil tcnt tcnt)
                                                             (.next this))))
                        (cons [this o] (clojure.core/cons o this))
                        (empty [_] (if (= cnt tcnt) nil (OPSeq. 0 nil tcnt tcnt)))
                        (equiv [this o] (if (or (not= (type this) (type o))
                                                (not= cnt (.cnt ^OPSeq o)) (not= tcnt (.tcnt ^OPSeq o))
                                                (not= i (.i ^OPSeq o))) false true))
                        clojure.lang.Counted
                          (count [_] (- tcnt cnt))
                        clojure.lang.Seqable
                          (clojure.lang.Seqable/seq [this] (if (= cnt tcnt) nil this))
                        clojure.lang.IReduce
                          (reduce [_ f v] (let [c (- tcnt cnt)]
                                            (if (<= c 0) nil
                                              (loop [ci i, n c, rslt v]
                                                (if (zero? (bit-and (aget cmpsa (bit-shift-right ci 6))
                                                                    (bit-shift-left 1 (bit-and ci 63))))
                                                  (let [rrslt (f rslt (+ ci ci 3)),
                                                        rdcd (reduced? rrslt),
                                                        nrslt (if rdcd @rrslt rrslt)]
                                                    (if (or (<= n 1) rdcd) nrslt
                                                      (recur (inc ci) (dec n) nrslt)))
                                                  (recur (inc ci) n rslt))))))
                          (reduce [this f] (if (nil? i) (f) (if (= (.count this) 1) (+ i i 3)
                                                              (.reduce ^clojure.lang.IReduce (.next this) f (+ i i 3)))))
                        clojure.lang.Sequential
                        Object
                          (toString [this] (if (= cnt tcnt) "()"
                                             (.toString (seq (map identity this))))))
                    (->OPSeq 0 cmpsts 0 (numprms))))))))
