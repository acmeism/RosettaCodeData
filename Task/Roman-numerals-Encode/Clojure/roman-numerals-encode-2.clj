(def arabic-roman-map
     {1 "I", 5 "V",
      10 "X", 50 "L",
      100 "C", 500 "D",
      1000 "M",
      4 "IV", 9 "IX",
      40 "XL", 90 "XC",
      400 "CD", 900 "CM" })

(def arabic-roman-map-sorted-keys
     (sort (keys arabic-roman-map)))

(defn find-value-in-coll
  [coll k]
  (let [aval (find coll k)]
  (if (nil? aval) "" (val aval))))

(defn to-roman
  [result n]
  (let
      [closest-key-for-n (last (filter #(> n %) arabic-roman-map-sorted-keys))
       roman-value-for-n (find-value-in-coll arabic-roman-map n)
       roman-value-for-closet-to-n (find-value-in-coll arabic-roman-map
						      closest-key-for-n)]
       (if (or (<= n 0)(contains? arabic-roman-map n))
	 (conj result roman-value-for-n)
	 (recur (conj result roman-value-for-closet-to-n)
		(- n closest-key-for-n)))))

Usage: >(to-roman [] 1999)
result: ["M" "CM" "XC" "IX"]
