(local (prev)
  (dotimes (i (length all-readings))
    (unless (= 1 (all-readings i -2))
      (setq prev
        (if (zero? i) 0 (all-readings (- i 1) -1)))
      (setf (all-readings i -1) (+ 1 prev))))
  'ok)
