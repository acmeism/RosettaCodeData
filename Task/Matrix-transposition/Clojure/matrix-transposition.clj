(defmulti matrix-transpose
  "Switch rows with columns."
  class)

(defmethod matrix-transpose clojure.lang.PersistentList
  [mtx]
  (apply map list mtx))

(defmethod matrix-transpose clojure.lang.PersistentVector
  [mtx]
  (apply mapv vector mtx))
