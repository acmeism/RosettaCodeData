(defn make-list [separator]
  (var i 0)
  (defn make-item [item]
    (printf "%d%s%s" (++ i) separator item))
  (make-item "first")
  (make-item "second")
  (make-item "third"))

(make-list ". ")
