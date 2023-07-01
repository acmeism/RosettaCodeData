(defun factors (n)
  (factors n 2 '()))

(defun factors
  ((1 _ acc)
    acc)
  ((n k acc) (when (== 0 (rem n k)))
    (factors (div n k) k (cons k acc)))
  ((n k acc)
    (factors n (+ k 1) acc)))
