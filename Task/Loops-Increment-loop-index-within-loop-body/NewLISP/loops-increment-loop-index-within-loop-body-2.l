(define (prime? n) (= 1 (length (factor (int n)))))
(define (commafy n) (reverse (join (explode (reverse (string n)) 3) ",")))

(let (i 42
      cnt 0)
  (while (< cnt 42)
    (++ i)
    (when (prime? i)
      (++ cnt)
      (println (format "Prime %2d.  %18s" cnt (commafy i)))
      (++ i i))))
