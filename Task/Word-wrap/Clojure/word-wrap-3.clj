;; cl-format based version
(defn wrap-line [size text]
  (clojure.pprint/cl-format nil (str "~{~<~%~1," size ":;~A~> ~}") (clojure.string/split text #" ")))
