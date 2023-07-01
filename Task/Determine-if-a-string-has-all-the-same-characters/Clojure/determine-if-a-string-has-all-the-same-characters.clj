(defn check-all-chars-same [s]
  (println (format "String (%s) of len: %d" s (count s)))
  (let [num-same (-> (take-while #(= (first s) %) s)
                     count)]
    (if (= num-same (count s))
      (println "...all characters the same")
      (println (format "...character %d differs - it is 0x%x"
                       num-same
                       (byte (nth s num-same)))))))

  (map check-all-chars-same
         [""
          "   "
          "2"
          "333"
          ".55"
          "tttTTT"
          "4444 444k"])
