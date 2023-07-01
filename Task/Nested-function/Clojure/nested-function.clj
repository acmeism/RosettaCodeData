(defn make-list [separator]
  (let [x (atom 0)]
    (letfn [(make-item [item] (swap! x inc) (println (format "%s%s%s" @x separator item)))]
      (make-item "first")
      (make-item "second")
      (make-item "third"))))

(make-list ". ")
