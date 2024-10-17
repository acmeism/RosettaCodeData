(define (sum-day day)
  (letn (lst (filter (fn(a) (= 1 (a 2))) (get-day day))
         tot (apply add (map first lst)))
    (println (format "%s Good readings: %d  Total: %.3f  Avg.: %.3f"
      day (length lst) tot
      (div tot (if (zero? (length lst)) 0 (length lst)))))))

(sum-day "1993-03-05")
