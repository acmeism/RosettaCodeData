(apply str (interpose " " (sort (filter #(.startsWith % "*") (map str (keys (ns-publics 'clojure.core)))))))
