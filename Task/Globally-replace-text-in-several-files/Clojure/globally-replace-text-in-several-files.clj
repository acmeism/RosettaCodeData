(defn hello-goodbye [& more]
  (doseq [file more]
    (spit file (.replace (slurp file) "Goodbye London!" "Hello New York!"))))
