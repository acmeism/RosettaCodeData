(defn rep-string [s]
  (let [len        (count s)
        first-half (subs s 0 (/ len 2))
        test-group (take-while seq (iterate butlast first-half))
        test-reptd (map (comp #(take len %) cycle) test-group)]
    (some #(= (seq s) %) test-reptd)))
