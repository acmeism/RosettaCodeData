(def a (ref 0))
(def a-history (atom [@a])) ; define a history vector to act as a stack for changes on variable a
(add-watch a :hist (fn [key ref old new] (swap! a-history conj new)))
