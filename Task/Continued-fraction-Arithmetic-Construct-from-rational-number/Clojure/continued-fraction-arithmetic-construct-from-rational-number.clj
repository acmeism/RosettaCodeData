(defn r2cf [n d]
  (if-not (= d 0) (cons (quot n d) (lazy-seq (r2cf d (rem n d))))))

; Example usage
(def demo '((1 2)
            (3 1)
            (23 8)
            (13 11)
            (22 7)
            (-151 77)
            (14142 10000)
            (141421 100000)
            (1414214 1000000)
            (14142136 10000000)
            (31 10)
            (314 100)
            (3142 1000)
            (31428 10000)
            (314285 100000)
            (3142857 1000000)
            (31428571 10000000)
            (314285714 100000000)
            (3141592653589793 1000000000000000)))

(doseq [inputs demo
        :let [outputs (r2cf (first inputs) (last inputs))]]
  (println inputs ";" outputs))
