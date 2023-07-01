(= leap? (fn (year)
  (if (and (is 0 (mod year 4)) (isnt 0 (mod year 100))) year
      (unless (< 0 (+ (mod year 100) (mod year 400))) year))))
