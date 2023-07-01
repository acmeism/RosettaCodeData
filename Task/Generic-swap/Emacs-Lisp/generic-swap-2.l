(defmacro swap (a b)
  `(setq ,b (prog1 ,a (setq ,a ,b))))
