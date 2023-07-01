(defn ints-from [n]
  (cons n (lazy-seq (ints-from (inc n)))))

(defn drop-nth [n seq]
   (cond
      (zero?    n) seq
      (empty? seq) []
      :else (concat (take (dec n) seq) (lazy-seq (drop-nth n (drop n seq))))))

(def ludic ((fn ludic
   ([] (ludic 1))
   ([n] (ludic n (ints-from (inc n))))
   ([n [f & r]] (cons n (lazy-seq (ludic f (drop-nth f r))))))))

(defn ludic? [n]  (= (first (filter (partial <= n) ludic)) n))

(print "First 25: ")
(println (take 25 ludic))
(print "Count below 1000: ")
(println (count (take-while (partial > 1000) ludic)))
(print "2000th through 2005th: ")
(println (map (partial nth ludic) (range 1999 2005)))
(print "Triplets < 250: ")
(println (filter (partial every? ludic?)
         (for [i (range 250)] (list i (+ i 2) (+ i 6)))))
