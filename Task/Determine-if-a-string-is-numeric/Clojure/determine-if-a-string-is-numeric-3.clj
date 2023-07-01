(require '[clojure.edn :as edn])
(import [java.io PushbackReader StringReader])

(defn number-string? [s]
  (boolean
    (when (and (string? s) (re-matches #"^[+-]?\d.*" s))
      (let [reader (PushbackReader. (StringReader. s))
            num (try (edn/read reader) (catch Exception _ nil))]
        (when num
          ; Check that the string has nothing after the number
          (= -1 (.read reader)))))))
