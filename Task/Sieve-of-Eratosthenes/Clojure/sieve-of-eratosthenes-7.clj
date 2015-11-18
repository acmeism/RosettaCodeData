(defn primes-Bird
  "Computes the unbounded sequence of primes using a Sieve of Eratosthenes algorithm by Richard Bird."
  []
  (letfn [(mltpls [p] (let [p2 (* 2 p)]
                        (letfn [(nxtmltpl [c]
                                  (cons c (lazy-seq (nxtmltpl (+ c p2)))))]
                          (nxtmltpl (* p p))))),
          (allmtpls [ps] (cons (mltpls (first ps)) (lazy-seq (allmtpls (next ps))))),
          (union [xs ys] (let [xv (first xs), yv (first ys)]
                           (if (< xv yv) (cons xv (lazy-seq (union (next xs) ys)))
                             (if (< yv xv) (cons yv (lazy-seq (union xs (next ys))))
                               (cons xv (lazy-seq (union (next xs) (next ys)))))))),
          (mrgmltpls [mltplss] (cons (first (first mltplss))
                                     (lazy-seq (union (next (first mltplss))
                                                      (mrgmltpls (next mltplss)))))),
          (minusStrtAt [n cmpsts] (loop [n n, cmpsts cmpsts]
                                    (if (< n (first cmpsts))
                                      (cons n (lazy-seq (minusStrtAt (+ n 2) cmpsts)))
                                      (recur (+ n 2) (next cmpsts)))))]
    (do (def oddprms (cons 3 (lazy-seq (let [cmpsts (-> oddprms (allmtpls) (mrgmltpls))]
                                         (minusStrtAt 5 cmpsts)))))
        (cons 2 (lazy-seq oddprms)))))
