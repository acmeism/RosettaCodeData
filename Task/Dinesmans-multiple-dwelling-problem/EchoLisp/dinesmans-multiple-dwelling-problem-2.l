(define names '("baker" "cooper" "fletcher" "miller" "smith" ))

(define-syntax-rule (floor name) (hash-ref H name))
(define-syntax-rule (touch a b) (= (abs (- (hash-ref H a) (hash-ref H b))) 1))

(define (constraints floors H)
(define top (1- (length floors)))
    ;; Baker does not live on the top floor.
    (amb-require (!=  (floor "baker")  top))
    ;; Cooper does not live on the bottom floor.
    (amb-require (!=  (floor "cooper") 0))
    ;; Fletcher does not live on either the top or the bottom floor.
    (amb-require (!= (floor "fletcher") top))
    (amb-require (!= (floor "fletcher") 0))
    ;; Miller lives on a higher floor than does Cooper.
    (amb-require (> (floor "miller") (floor "cooper")))
     ;; Smith does not live on a floor adjacent to Fletcher's.
    (amb-require (not (touch "smith" "fletcher")))
    ;; Fletcher does not live on a floor adjacent to Cooper's.
    (amb-require (not (touch "fletcher" "cooper")))
)
