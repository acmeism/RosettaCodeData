(ns rosettacode.hofstader-conway
  (:use [clojure.math.numeric-tower :only [expt]]))

;; A literal transcription of the definition, with memoize doing the heavy lifting
(def conway
  (memoize
    (fn [x]
      (if (< x 3)
        1
        (+  (-> x dec conway conway)
           (->> x dec conway (- x) conway))))))

(let [N      (drop 1 (range))
      pow2   (map #(expt 2 %) N)
      ; Split the natural numbers into groups at each power of two
      groups (partition-by (fn [x] (filter #(> % x) pow2)) N)
      maxima (->> (map #(map conway %) groups)
                  (map #(map / %2 %1) groups)  ; Each conway number divided by its index
                  (map #(apply max %)))
      m20    (take 20 maxima)]
  (println
    (take 4 maxima) "\n"
    (apply >= m20)  "\n"
    (map double m20)))   ; output the decimal forms
