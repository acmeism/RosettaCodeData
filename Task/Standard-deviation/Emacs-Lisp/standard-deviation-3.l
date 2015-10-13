(setq x '[2 4 4 4 5 5 7 9])
(string-to-number (calc-eval (format "sqrt(vpvar(%s))" x)))
