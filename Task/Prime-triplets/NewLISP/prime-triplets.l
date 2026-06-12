(define (prime? n) (= 1 (length (factor n))))

(for (n 3 5500)
  (let (trip (list n (+ 2 n) (+ 6 n)))
    (if (for-all prime? trip) (println trip))))

