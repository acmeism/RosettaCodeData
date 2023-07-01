(do ((number 0) (okp t))
    ((or (not okp) (= 75000 number)))
  (multiple-value-setq (number okp)
      (capi:prompt-for-integer "Enter an integer:")))
