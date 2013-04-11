(defn foo [& opts]
  (let [opts (merge {:bar 1 :baz 2} (apply hash-map opts))
        {:keys [bar baz]} opts]
    [bar baz]))
