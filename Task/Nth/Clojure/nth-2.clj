(apply str (interpose " " (map #(clojure.pprint/cl-format nil "~:R" %) (range 0 26))))
