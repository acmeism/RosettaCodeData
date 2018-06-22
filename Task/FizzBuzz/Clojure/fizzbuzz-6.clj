(defn fizz-buzz
  ([] (fizz-buzz (range 1 101)))
  ([lst]
     (letfn [(fizz? [n] (zero? (mod n 3)))
	     (buzz? [n] (zero? (mod n 5)))]
       (let [f     "Fizz"
	     b     "Buzz"
	     items (map (fn [n]
			  (cond (and (fizz? n) (buzz? n)) (str f b)
				(fizz? n) f
				(buzz? n) b
				:else n))
			lst)] items))))
