#;(for ([x (in-range 1 (add1 99))])
    (show-info x))
(for ([x (in-range 1 (add1 15))])
  (show-info x))

(newline)
(show-info 18)
(show-info 46)
(show-info 99)

(newline)
(printf "Total ancestors up to 99: ~a\n" (total-ancestors 99))
(printf "Total descendants up to 99: ~a\n" (total-descendants 99))
