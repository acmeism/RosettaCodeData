(defn exp [n k] (reduce * (repeat k n)))

(def big (->> 2 (exp 3) (exp 4) (exp 5)))
(def sbig (str big))

(assert (= "62060698786608744707" (.substring sbig 0 20)))
(assert (= "92256259918212890625" (.substring sbig (- (count sbig) 20))))
(println (count sbig) "digits")

(println (str (.substring sbig 0 20) ".."
	      (.substring sbig (- (count sbig) 20)))
	 (str "(" (count sbig) " digits)"))
