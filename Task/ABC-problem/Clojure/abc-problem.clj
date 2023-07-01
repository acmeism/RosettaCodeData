(def blocks
  (-> "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM" (.split " ") vec))

(defn omit
  "return bs with (one instance of) b omitted"
  [bs b]
  (let [[before after] (split-with #(not= b %) bs)]
    (concat before (rest after))))

(defn abc
  "return lazy sequence of solutions (i.e. block lists)"
  [blocks [c & cs]]
  (if (some? c)
    (for [b blocks :when (some #(= c %) b)
          bs (abc (omit blocks b) cs)]
      (cons b bs))
    [[]]))


(doseq [word ["A" "BARK" "Book" "treat" "COMMON" "SQUAD" "CONFUSE"]]
  (->> word .toUpperCase (abc blocks) first (printf "%s: %b\n" word)))
