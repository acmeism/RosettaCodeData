; Compute the Unsigned Lah number L(n, k).
(define lah
  (lambda (n k)
    (/ (/ (* (fact n) (fact (1- n))) (* (fact k) (fact (1- k)))) (fact (- n k)))))

; Procedure to compute factorial.
(define fact
  (lambda (n)
    (if (<= n 0)
      1
      (* n (fact (1- n))))))

; Generate a table of the Unsigned Lah numbers L(n, k) up to L(12, 12).
(printf "The Unsigned Lah numbers L(n, k) up to L(12, 12):~%")
(printf "n\\k~10d" 1)
(do ((k 2 (1+ k)))
    ((> k 12))
  (printf " ~10d" k))
(newline)
(do ((n 1 (1+ n)))
    ((> n 12))
  (printf "~2d" n)
  (do ((k 1 (1+ k)))
      ((> k n))
    (printf " ~10d" (lah n k)))
  (newline))

; Find the maximum value of L(n, k) where n = 100.
(printf "~%The maximum value of L(n, k) where n = 100:~%")
(let ((max 0))
  (do ((k 1 (1+ k)))
      ((> k 100))
    (let ((val (lah 100 k)))
      (when (> val max) (set! max val))))
  (printf "~d~%" max))
