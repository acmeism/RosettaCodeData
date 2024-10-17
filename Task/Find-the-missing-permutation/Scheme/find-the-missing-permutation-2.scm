(use srfi-197)

(chain
  *permutations*
  (map string->list _)
  (apply map list _)
  (map group-collection _)
  (map (lambda(xs) (find-min xs :key length)) _)
  (map car _)
  (apply string _))
