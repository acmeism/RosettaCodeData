(defn paragraph [num]
  (str num " bottles of beer on the wall\n"
       num " bottles of beer\n"
       "Take one down, pass it around\n"
       (dec num) " bottles of beer on the wall.\n"))

(defn lyrics []
  (let [numbers (range 99 0 -1)
        paragraphs (map paragraph numbers)]
    (clojure.string/join "\n" paragraphs)))


(print (lyrics))
