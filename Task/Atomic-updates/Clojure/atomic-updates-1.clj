(defn xfer [m from to amt]
  (let [{f-bal from t-bal to} m
        f-bal (- f-bal amt)
        t-bal (+ t-bal amt)]
    (if (or (neg? f-bal) (neg? t-bal))
      (throw (IllegalArgumentException. "Call results in negative balance."))
      (assoc m from f-bal to t-bal))))
