(define deck
  (shuffle new-deck))

(define hand
  (list))

(deal! deck hand)
(deal! deck hand)
(deal! deck hand)
(deal! deck hand)
(deal! deck hand)

(display hand)
(newline)
