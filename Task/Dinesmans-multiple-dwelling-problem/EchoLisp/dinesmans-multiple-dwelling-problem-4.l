;; add a  name/floor
(define names '("baker" "cooper" "fletcher" "miller" "smith"  "antoinette"))

(define (constraints floors H)
;; ... same as above, add the following

     ;; Antoinette does not like 💔 Smith
     (amb-require (not (touch "smith" "antoinette")))
    ;; Antoinette is very close  ❤️ to Cooper
     (amb-require (touch "cooper" "antoinette"))
    ;; Antoinette wants a prime numbered floor
     (amb-require (prime? (floor "antoinette")))
)

