(setq len (apply max (clean zero? (map last all-readings))))
(println "Longest run of bad readings: " len)
