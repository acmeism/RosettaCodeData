(def test-cases [1 2 3 4 5 11 65 100 101 272 23456 8007006005004003])
(pprint
  (sort (zipmap test-cases (map #(clojure.pprint/cl-format nil "~:R" %) test-cases))))
