(setq x '[1 2 3 4])
(string-to-number (calc-eval (format "vmean(%s)" x)))
