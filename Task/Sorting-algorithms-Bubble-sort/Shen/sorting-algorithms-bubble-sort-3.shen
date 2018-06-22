(tc +)

(define bubble-shot
  { (vector number) --> (vector number) }
  (@v A <>) -> (@v A <>)
  (@v A B R) -> (@v B (bubble-shot (@v A R))) where (> A B)
  (@v A R) -> (@v A (bubble-shot R)))

(define bubble-sort
  { (vector number) --> (vector number) }
  X -> (fix (function bubble-shot) X))
