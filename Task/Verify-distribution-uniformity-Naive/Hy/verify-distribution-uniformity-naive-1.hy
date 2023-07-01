(import [collections [Counter]])
(import [random [randint]])

(defn uniform? [f repeats delta]
; Call 'f' 'repeats' times, then check if the proportion of each
; value seen is within 'delta' of the reciprocal of the count
; of distinct values.
  (setv bins (Counter (list-comp (f) [i (range repeats)])))
  (setv target (/ 1 (len bins)))
  (all (list-comp
    (<= (- target delta) (/ n repeats) (+ target delta))
    [n (.values bins)])))
