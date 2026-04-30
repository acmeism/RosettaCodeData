(defn a [i] (print "a") i)
(defn b [j] (print "b") j)

(loop [i :in [false true] j :in [false true]]
  (printf "%v and %v:" i j)
  (and (a i) (b j))
  (printf "%v or %v:" i j)
  (or (a i) (b j)))
