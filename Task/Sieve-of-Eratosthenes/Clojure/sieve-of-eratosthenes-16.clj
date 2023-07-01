(defn primes-pq
  "Infinite sequence of primes using an incremental Sieve or Eratosthenes with a Priority Queue"
  []
  (letfn [(nxtoddprm [c q bsprms cmpsts]
            (if (>= c q) ;; only ever equal
              (let [p2 (* (first bsprms) 2), nbps (next bsprms), nbp (first nbps)]
                (recur (+ c 2) (* nbp nbp) nbps (insert-pq cmpsts (+ q p2) p2)))
              (let [mn (getMin-pq cmpsts)]
                (if (and mn (>= c (.k mn))) ;; never greater than
                  (recur (+ c 2) q bsprms
                         (loop [adv (.v mn), cmps cmpsts] ;; advance repeat composites for value
                           (let [ncmps (replaceMinAs-pq cmps (+ c adv) adv),
                                 nmn (getMin-pq ncmps)]
                             (if (and nmn (>= c (.k nmn)))
                               (recur (.v nmn) ncmps)
                               ncmps))))
                  (cons c (lazy-seq (nxtoddprm (+ c 2) q bsprms cmpsts)))))))]
    (do (def baseoddprms (cons 3 (lazy-seq (nxtoddprm 5 9 baseoddprms (empty-pq)))))
        (cons 2 (lazy-seq (nxtoddprm 3 9 baseoddprms (empty-pq)))))))
