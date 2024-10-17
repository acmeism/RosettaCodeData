(define (foo row)
  (letn (no-bishops (replace "B" (copy row) "")
         no-queen (replace "Q" (copy no-bishops) "")
         n-pattern (replace {[^N]} (copy no-queen) "-" 0)
         n-table
           '("NN---" "N-N--" "N--N-" "N---N" "-NN--" "-N-N-"
             "-N--N" "--NN-" "--N-N" "---NN")
         n-number (find n-pattern n-table)
         queen (find "Q" no-bishops)
         bishop-dark (find {B.} (explode row 2) 0)
         bishop-light (find {.B} (explode row 2) 0))
    (+ (* 96 n-number) (* 16 queen) (* 4 bishop-dark) bishop-light)))

(dolist (p '("RNBQKBNR" "QNRBBNKR" "RQNBBKRN" "RNQBBKRN"))
  (println p " " (foo p)))
