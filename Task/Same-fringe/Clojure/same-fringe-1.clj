(defn fringe-seq [branch? children content tree]
  (letfn [(walk [node]
            (lazy-seq
              (if (branch? node)
                (if (empty? (children node))
                  (list (content node))
                  (mapcat walk (children node)))
                (list node))))]
    (walk tree)))
