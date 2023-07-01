(defn van-eck
  ([] (van-eck 0 0 {}))
  ([val n seen]
   (lazy-seq
    (cons val
          (let [next (- n (get seen val n))]
            (van-eck next
                     (inc n)
                     (assoc seen val n)))))))

(println "First 10 terms:" (take 10 (van-eck)))
(println "Terms 991 to 1000 terms:" (take 10 (drop 990 (van-eck))))
