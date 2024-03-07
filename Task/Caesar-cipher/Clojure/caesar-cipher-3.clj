(defn fast-caesar [n s]
  (let [m (mod n 26)
        upper (map char (range 65 91))
        upper->new (zipmap upper (drop m (cycle upper)))
        lower (map char (range 97 123))
        lower->new (zipmap lower (drop m (cycle lower)))]
    (clojure.string/escape s (merge upper->new lower->new))))
