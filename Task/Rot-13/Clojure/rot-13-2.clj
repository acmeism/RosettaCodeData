(let [A (into #{} "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
      A-map (zipmap A (take 52 (drop 26 (cycle A))))]

  (defn rot13[in-str]
    (reduce str (map #(if (A %1) (A-map %1) %1)  in-str))))

(rot13 "The Quick Brown Fox Jumped Over The Lazy Dog!") ;; produces "Gur Dhvpx Oebja Sbk Whzcrq Bire Gur Ynml Qbt!"
