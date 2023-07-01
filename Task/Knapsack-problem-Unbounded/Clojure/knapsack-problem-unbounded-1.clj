(defstruct item :value :weight :volume)

(defn total [key items quantities]
  (reduce + (map * quantities (map key items))))

(defn max-count [item max-weight max-volume]
  (let [mcw (/ max-weight (:weight item))
        mcv (/ max-volume (:volume item))]
    (min mcw mcv)))
