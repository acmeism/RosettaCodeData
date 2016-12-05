;; from Racket
(define count-substring
   (compose length regexp-match*))

(count-substring "aab" "graabaabdfaabgh") ;; substring
    → 3
(count-substring "/ .e/" "Longtemps je me suis couché de bonne heure") ;; regexp
    → 4
