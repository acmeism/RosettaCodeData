(defun factors (n)
  (list-comp
    ((<- i (when (== 0 (rem n i))) (lists:seq 1 (trunc (/ n 2)))))
    i))
