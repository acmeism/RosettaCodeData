Rebol [
  title: "Rosetta code: Playing cards"
  file:  %Playing_cards.r3
  url:   https://rosettacode.org/wiki/Playing_cards
  note:  "Based on Red language solution"
  needs: 3.0.0
]
random/seed 1                        ;; Seed the random number generator for reproducibility

make-deck: function/with [] [
    new-deck: make block! 52         ;; Create an empty block for 52 cards
    foreach s suit [                 ;; For each suit...
        foreach r rank [             ;; ...and for each rank...
            append new-deck join r s ;; ...make a card by joining rank and suit (e.g., "Q♠") and add to deck
        ]
    ]
][
    rank: "A23456789TJQK"            ;; All ranks in a suit (Ace, 2 .. 9, Ten, Jack, Queen, King)
    suit: "♣♦♥♠"                     ;; All four suits: clubs, diamonds, hearts, spades
]

deal: func [
    other-deck [block!]              ;; Deck to deal card(s) into
    deck [block!]                    ;; Deck to deal card(s) from
][
    unless empty? deck [
        append other-deck take deck  ;; If cards remain, take the top card and append to other deck
    ]
]

contents: func [deck [block!]] [
    repeat i length? deck [
        prin [deck/:i SP]            ;; Print each card with
        if zero? i % 12  [prin LF]   ;; Newline after every 12 cards for readability
    ]
]

deck: random make-deck               ;; Create and shuffle a new deck

print "40 cards from a deck:"
loop 5 [                             ;; 5 lines total
    prin LF                          ;; Blank line to separate each row
    loop 8 [prin [take deck SP]]     ;; Deal 8 cards per line, remove from deck and print
]
prin "^/^/remaining: " contents deck ;; Print all remaining cards in deck, 12 per line
