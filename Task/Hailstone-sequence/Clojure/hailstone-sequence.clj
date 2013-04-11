(defn hailstone-seq [n]
  (:pre [(pos? n)])
  (lazy-seq
   (cond (= n 1)   '(1)
         (even? n) (cons n (hailstone-seq (/ n 2)))
         :else     (cons n (hailstone-seq (+ (* n 3) 1))))))

(def hseq27 (hailstone-seq 27))
(assert (= (count hseq27) 112))
(assert (= (take 4 hseq27) [27 82 41 124]))
(assert (= (drop 108 hseq27) [8 4 2 1]))

(let [{max-i :num, max-len :len}
      (reduce #(max-key :len %1 %2)
              (for [i (range 1 100000)]
                {:num i, :len (count (hailstone-seq i))}))]
  (println "Maximum length" max-len "was found for hailstone(" max-i ")."))
