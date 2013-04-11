(defn foo [& {:keys [bar baz] :or {bar 1, baz 2}}]
  [bar baz])
