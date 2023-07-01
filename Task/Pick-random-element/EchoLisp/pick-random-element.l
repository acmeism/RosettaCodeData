(define (pick-random list)
    (list-ref list (random (length list))))
(pick-random (iota 1000)) → 667
(pick-random (iota 1000)) → 179
