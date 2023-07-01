(defn quibble [sq]
  (let [sep (if (pos? (count sq)) " and " "")]
    (apply str
      (concat "{" (interpose ", " (butlast sq)) [sep (last sq)] "}"))))

; Or, using clojure.pprint's cl-format, which implements common lisp's format:
(defn quibble-f [& args]
  (clojure.pprint/cl-format nil "{~{~a~#[~; and ~:;, ~]~}}" args))

(def test
  #(doseq [sq [[]
               ["ABC"]
               ["ABC", "DEF"]
               ["ABC", "DEF", "G", "H"]]]
     ((comp println %) sq)))

(test quibble)
(test quibble-f)
