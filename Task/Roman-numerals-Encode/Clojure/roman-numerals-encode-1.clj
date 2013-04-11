(def arabic->roman
  (partial clojure.pprint/cl-format nil "~@R"))

(arabic->roman 147)
;"CXXIII"
(arabic->roman 99)
;"XCIX"
