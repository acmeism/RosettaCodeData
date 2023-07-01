(require '[clojure.core.async :refer [go <! timeout]])
(doseq [text ["Enjoy" "Rosetta" "Code"]]
  (go
    (<! (timeout (rand-int 1000))) ; wait a random fraction of a second,
    (println text)))
