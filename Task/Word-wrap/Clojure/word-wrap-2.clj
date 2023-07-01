;; Wrap line base on regular expression
(defn wrap-line [size text]
  (re-seq (re-pattern (str ".{1," size "}\\s|.{1," size "}"))
          (clojure.string/replace text #"\n" " ")))
