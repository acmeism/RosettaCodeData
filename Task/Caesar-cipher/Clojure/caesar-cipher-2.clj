(defn encode [k s]
  (let [f #(take 26 (drop %3 (cycle (range (int %1) (inc (int %2))))))
        a #(map char (concat (f \a \z %) (f \A \Z %)))]
    (apply str (replace (zipmap (a 0) (a k)) s))))

(defn decode [k s]
  (encode (- 26 k) s))
