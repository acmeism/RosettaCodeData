;; the initial level
(def level (atom 41))

;; the probability of success
(def prob 0.5001)


(defn step
  []
  (let [success (< (rand) prob)]
    (swap! level (if success inc dec))
    success) )
