(doseq [{:keys [tag attrs]} (xml-seq students)]
  (if (= :Student tag)
    (println (:Name attrs))))
