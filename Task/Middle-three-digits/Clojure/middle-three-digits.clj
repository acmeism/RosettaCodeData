(defn middle3
  [v]
  (let [digit-str (str (Math/abs v))
        len (count digit-str)]
    (cond
      (< len 3) :too-short
      (even? len) :even-digit-count
      :else (let [half (/ len 2)]
              (subs digit-str (- half 1) (+ half 2))))))

(clojure.pprint/print-table
 (for [i [123 12345 1234567 987654321 10001 -10001 -123 -100 100 -12345
          1 2 -1 -10 2002 -2002 0]]
   {:i i :middle-3 (middle3 i)}))
