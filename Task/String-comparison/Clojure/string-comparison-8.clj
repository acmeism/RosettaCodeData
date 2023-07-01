(defn istr [s]
  (.intern s))

(def s3 (istr s1))
(def s4 (istr s2))

(= s3 s4)           ; true
(identical? s3 s4)  ; true
