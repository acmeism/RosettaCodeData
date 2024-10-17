(define (prime? n) (= 1 (length (factor (int n)))))

(define (powerset lst)
  (if lst
    (let (p (powerset (1 lst)))
      (append p (map (curry cons (lst 0)) p)))
    '(())))

(letn (primes
        (sort (filter prime?
          (map (fn (xs) (int (apply string (sort xs)) 0))
            (powerset (sequence 1 9)))))
       cnt)
  (dolist (n primes)
    (print (format "%9d" n))
    (if (zero? (% (++ cnt) 6)) (println)))
  (println "\n\nNumber found: " (length primes)))
