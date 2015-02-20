(let [cfg (read-string (slurp "config.edn"))]
  (clojure.pprint/pprint cfg))
