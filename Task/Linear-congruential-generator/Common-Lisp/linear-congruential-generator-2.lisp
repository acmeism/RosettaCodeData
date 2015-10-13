(defun linear-random (seed &key (times 1) (bounds (expt 2 31)) (multiplier 1103515245) (adder 12345) (divisor 1) (max 2147483647) (min 0))
  (loop for candidate = seed then (mod (+ (* multiplier candidate) adder) bounds)
     for result = candidate then (floor (/ candidate divisor))
     when (and (< result max) (> result min)) collect result into valid-numbers
     when (> (length valid-numbers) times) return result))
