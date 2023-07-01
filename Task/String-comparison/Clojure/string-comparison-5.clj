(defn str-caseless= [a b]
  (= (clojure.string/lower-case a)
     (clojure.string/lower-case b)))

(str-caseless= "foo" "fOO")   ; true
