(ns rosetta-code.frequent-hailstone-lengths
  (:require [rosetta-code.hailstone-sequence
             :refer [hailstone-seq]]))

(defn -main [& args]
  (let [frequencies (apply merge-with +
                           (for [x (range 1 100000)]
                             {(count (hailstone-seq x)) 1}))
        [most-frequent-length frequency]
        (apply max-key val (seq frequencies))]
    (printf (str "The most frequent Hailstone sequence length for numbers under 100000 is %s,"
                 " with a frequency of %s.\n")
            most-frequent-length frequency)))
