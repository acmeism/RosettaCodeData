(defn quot-rem [m n] [(quot m n) (rem m n)])

; The following prints 3 2.
(let [[q r] (quot-rem 11 3)]
  (println q)
  (println r))
