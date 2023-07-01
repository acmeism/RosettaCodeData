(declare mm) ;forward decl for memoization function

(defn m [i w]
  (cond
    (< i 0) [0 []]
    (= w 0) [0 []]
    :else
    (let [{wi :weight vi :value} (get items i)]
      (if (> wi w)
        (mm (dec i) w)
        (let [[vn sn :as no]  (mm (dec i) w)
              [vy sy :as yes] (mm (dec i) (- w wi))]
          (if (> (+ vy vi) vn)
            [(+ vy vi) (conj sy i)]
            no))))))

(def mm (memoize m))
