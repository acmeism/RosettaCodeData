(= day-names '(Sunday Monday Tuesday Wednesday Thursday Friday Saturday))
(= get-weekday-num (fn (year month day)
   (= helper '(0 3 2 5 0 3 5 1 4 6 2 4))
   (if (< month 3) (= year (- year 1)))
   (mod (+ year (helper (- month 1)) day
        (apply + (map [trunc (/ year _)] '(4 -100 400))))
   7)))
(= get-weekday-name (fn (weekday-num) (day-names weekday-num)))
