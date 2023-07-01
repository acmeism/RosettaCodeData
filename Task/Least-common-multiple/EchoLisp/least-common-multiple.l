(lcm 0 9) → 0
(lcm 444 888)→ 888
(lcm 888 999) → 7992

(define (lcm* list) (foldl lcm (first list) list)) → lcm*
(lcm* '(444 888 999)) → 7992
