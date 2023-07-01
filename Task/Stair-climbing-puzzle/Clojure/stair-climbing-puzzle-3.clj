(defn step-up2
  "Non-tail-recursive. No numbers."
  []
  (if (not (step))
    (do (step-up2) ;; undo the fall
	(step-up2) ;; try again
	)
    true))
