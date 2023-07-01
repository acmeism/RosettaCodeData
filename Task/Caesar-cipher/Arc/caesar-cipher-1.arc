(= rot (fn (L N)
  (if
    (and (<= 65 L) (>= 90 L))
      (do
      (= L (- L 65))
      (= L (mod (+ N L) 26))
      (= L (+ L 65)))
    (and (<= 97 L) (>= 122 L))
      (do
      (= L (- L 97))
      (= L (mod (+ N L) 26))
      (= L (+ L 97))))
  L))

(= caesar (fn (text (o shift))
  (unless shift (= shift 13))
  (= output (map [int _] (coerce text 'cons)))
  (= output (map [rot _ shift] output))
  (string output)
  ))
