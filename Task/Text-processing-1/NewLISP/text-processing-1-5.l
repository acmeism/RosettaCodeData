(setq days
  (map (fn(i) (all-readings i 1))
    (index (curry = len) (map last all-readings))))
(println "Bad runs with that length ended on these days: " days)
