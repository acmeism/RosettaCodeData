(defn matches-extension [ext s]
  (re-find (re-pattern (str "\\." ext "$"))
           (clojure.string/lower-case s)))

(defn matches-extension-list [ext-list s]
  (some #(matches-extension % s) ext-list))
