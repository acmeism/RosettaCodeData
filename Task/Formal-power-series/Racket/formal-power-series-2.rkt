(define <sin> (cons 0 (int <cos>)))
(define <cos> (cons 1 (scale -1 (int <sin>))))

-> (!! (take 10 <sin>))
'(0 1 0 -1/6 0 1/120 0 -1/5040 0 1/362880)

-> (!! (take 10 <cos>))
'(1 0 -1/2 0 1/24 0 -1/720 0 1/40320 0)

-> (!! (take 10 (diff <sin>)))
'(1 0 -1/2 0 1/24 0 -1/720 0 1/40320 0)

; sin(x)² + cos(x)² = 1
-> (!! (take 10 (<+> (<*> <cos> <cos>) (<*> <sin> <sin>))))
'(1 0 0 0 0 0 0 0 0 0)

; series of (tan x)
-> (!! (take 10 (</> <sin> <cos>)))
'(0 1 0 1/3 0 2/15 0 17/315 0 62/2835)
