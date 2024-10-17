(define (prime? n) (= 1 (length (factor (int n)))))

(define (next-clean-prime n)
  (do-until (and (prime? n) (not (find "0" (string n))))
    (-- n)))

(define (check p i)
  (let (s (string p))
    (until (or (empty? s) (not (prime? s)))
      (pop s i))
    (when (empty? s)
      ;; Dynamic scope.
      (if (zero? i) (setf lefty p) (setf righty p)))))

(define (foo   , lefty righty)
  (let (p 1000000)
    (until (and lefty righty)
      (set 'p (next-clean-prime p))
      (unless lefty (check p 0))
      (unless righty (check p -1)))
    (list lefty righty)))

(foo)
