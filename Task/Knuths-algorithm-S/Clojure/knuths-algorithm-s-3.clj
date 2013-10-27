(defn s-of-n-creator [n]
  (let [state (atom [[] 0])
        s-of-n-fn (s-of-n-fn-creator n)]
    (fn [item]
      (first (swap! state s-of-n-fn item)))))
