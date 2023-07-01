(get-name (findf (lambda (x) (< (get-population x) 5)) sorted-data))
;; -> "Khartoum-Omdurman"
(get-population (findf (lambda (x) (regexp-match? #rx"^A" (get-name x))) sorted-data))
;; -> 4.58
