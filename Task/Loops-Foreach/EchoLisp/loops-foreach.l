(define my-list '( albert simon antoinette))
(for ((h my-list)) (write h))
    albert simon antoinette

(define my-vector #(55 66 soixante-dix-sept))
(for (( u my-vector)) (write u))
    55 66 soixante-dix-sept

(define my-string "Longtemps")
(for ((une-lettre my-string)) (write une-lettre))
    "L" "o" "n" "g" "t" "e" "m" "p" "s"

;; etc ... for other collections like Streams, Hashes, Graphs, ...
