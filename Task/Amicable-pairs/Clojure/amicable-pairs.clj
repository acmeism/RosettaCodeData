(ns example
  (:gen-class))

(defn factors [n]
  " Find the proper factors of a number "
  (into (sorted-set)
        (mapcat (fn [x] (if (= x 1) [x] [x (/ n x)]))
                (filter #(zero? (rem n %)) (range 1 (inc (Math/sqrt n)))) )))


(def find-pairs (into #{}
               (for [n (range  2 20000)
                  :let [f (factors n)     ; Factors of n
                        M (apply + f)     ; Sum of factors
                        g (factors M)     ; Factors of sum
                        N (apply + g)]    ; Sum of Factors of sum
                  :when (= n N)           ; (sum(proDivs(N)) = M and sum(propDivs(M)) = N
                  :when (not= M N)]       ; N not-equal M
                 (sorted-set n M))))      ; Found pair

;; Output Results
(doseq [q find-pairs]
  (println q))
