(defn make-dict []
  (let [vals (range 0 256)]
    (zipmap (map (comp #'list #'char) vals) vals)))

(defn compress [#^String text]
  (loop [t (seq text)
         r '()
         w '()
         dict (make-dict)
         s 256]
    (let [c (first t)]
      (if c
        (let [wc (cons c w)]
          (if (get dict wc)
            (recur (rest t) r wc dict s)
            (recur (rest t) (cons (get dict w) r) (list c) (assoc dict wc s) (inc s))))
        (reverse (if w (cons (get dict w) r) r))))))

(compress "TOBEORNOTTOBEORTOBEORNOT")
