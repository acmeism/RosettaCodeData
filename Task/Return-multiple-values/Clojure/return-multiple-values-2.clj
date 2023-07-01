(defn quot-rem [m n]
  {:q (quot m n)
   :r (rem m n)})

; The following prints 3 2.
(let [{:keys [q r]} (quot-rem 11 3)]
  (println q)
  (println r))
