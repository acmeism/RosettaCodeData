;; Wrap line base on regular expression
(defn wrap-line [size text]
  (re-seq (re-pattern (str ".{0," size "}\\s"))
          (clojure.string/replace text #"\n" " ")))
