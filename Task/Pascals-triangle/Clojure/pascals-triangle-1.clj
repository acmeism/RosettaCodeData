(defn pascal [n]
  (let [newrow (fn newrow [lst ret]
                   (if lst
                       (recur (rest lst)
                              (conj ret (+ (first lst) (or (second lst) 0))))
                       ret))
        genrow (fn genrow [n lst]
                   (when (< 0 n)
                     (do (println lst)
                         (recur (dec n) (conj (newrow lst []) 1)))))]
    (genrow n [1])))
(pascal 4)
