(def nqueens (n (o queens))
  (if (< len.queens n)
    (let row (if queens (+ 1 queens.0.0) 0)
      (each col (range 0 (- n 1))
        (let new-queens (cons (list row col) queens)
          (if (no conflicts.new-queens)
            (nqueens n new-queens)))))
    (prn queens)))

; check if the first queen in 'queens' lies on the same column or diagonal as
; any of the others
(def conflicts (queens)
  (let (curr . rest) queens
    (or (let curr-column curr.1
          (some curr-column (map [_ 1] rest)))  ; columns
        (some [diagonal-match curr _] rest))))

(def diagonal-match (curr other)
  (is (abs (- curr.0 other.0))
      (abs (- curr.1 other.1))))
