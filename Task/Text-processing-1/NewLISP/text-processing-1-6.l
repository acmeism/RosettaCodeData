(setq grand-total (apply add (map first all-readings)))
(setq grand-count (length (filter zero? (map last all-readings))))
(println "Total number of bad readings: " (- (length all-readings) grand-count))
