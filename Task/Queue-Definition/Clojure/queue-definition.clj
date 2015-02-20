(defn make-queue []
  (atom []))

(defn enqueue [q x]
  (swap! q conj x))

(defn dequeue [q]
  (if-let [[f & r] (seq @q)]
    (do (reset! q r) f)
    (throw (IllegalStateException. "Can't pop an empty queue."))))

(defn queue-empty? [q]
  (empty? @q))
