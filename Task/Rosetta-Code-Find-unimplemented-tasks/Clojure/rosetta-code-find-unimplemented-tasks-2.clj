(defn titles-cont [url]
  (let [docseq (-> url xml/parse xml-seq)]
    ((juxt #(filter string? %), #(-> (filter map? %) first :cmcontinue))
      (for [{:keys [tag attrs content]} docseq :when (#{:cm :query-continue} tag)]
        (if (= tag :cm)
          (attrs :title)
          (-> content first :attrs))))))
