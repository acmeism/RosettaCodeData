(defn count-substring2 [txt sub]
  (-> sub
    (re-quote)
    (re-pattern)
    (re-matcher txt)
    (.results)
    (.count)))
