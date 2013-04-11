(defn rot-13 [c]
  (let [i (int c)]
    (cond
      (or (and (>= i (int \a)) (<= i (int \m)))
          (and (>= i (int \A)) (<= i (int \M))))
        (char (+ i 13))
      (or (and (>= i (int \n)) (<= i (int \z)))
          (and (>= i (int \N)) (<= i (int \Z))))
        (char (- i 13))
      :else c)))

(apply str (map rot-13 "abcxyzABCXYZ")) ;; output "nopklmNOPKLM"
