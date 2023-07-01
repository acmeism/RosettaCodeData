(defn step-up1
  "Straightforward implementation: keep track of how many level we
   need to ascend, and stop when this count is zero."
  []
  (loop [deficit 1]
    (or (zero? deficit)
	(recur (if (step) (dec deficit)
		   (inc deficit)))) ) )
