(defn file-extension [s]
  (second (re-find #"(\.[a-zA-Z0-9]+)$" s)))
